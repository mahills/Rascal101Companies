module rascal::hundred1Companies::Verify

import List;
import Set;
import Message;

import rascal::hundred1Companies::AST;

@doc{Verify a number of correctness conditions on the AST, marking errors so they can appear in Eclipse}
public set[Message] verify(Companies cs) {
	set[Message] errors = {};

	// Check 1: all company names are distinct
	cNames = { < c.name, c > | c <- cs.comps };
	for (c <- cNames<0>, size(cNames[c]) > 1)
		errors = errors + error(c@at, "Duplicate company name");
	
	// Check 2: Each company consists of (possibly nested) departments
	// NOTE: We do this here, instead of enforcing this in the grammar, so we can give
	// better error messages, not just parser error.
	for (c <- cs.comps)
		if (size(c.deps) == 0) errors = errors + error(c@at, "Company should contain at least one department");
		
	// Check 3: Each department (within a company) has a unique name
	depNames = { < c, d.name, d > | c <- cs.comps, / Department d <- c };
	for (c <- cs.comps, dname <- depNames[c]<0>, size(depNames[c,dname]) > 1)
		errors = errors + { error(d@at, "Department name is used more than once") | d <- depNames[c,dname] };
			
	// Check 4: Each department has a manager
	// Additional check: each department has EXACTLY ONE manager
	depMgrs = { < d, m > | / Department d <- cs, m:manager(_) <- d.empls };
	for (d <- depMgrs<0>, size(depMgrs[d]) > 1)
		errors = errors + error(d@at, "Department has multiple managers");
	for (d <- depNames<1>, size(depMgrs[d]) == 0)
		errors = errors + error(d@at, "Department has no managers");
	
	// Check 5: Each department aggregates employees and sub-departments
	// We could have departments without employees (except a manager, which is checked above),
	// and we could have departments without sub-departments. Check here to make sure we have
	// at least one sub-department or at least one employee.
	for (d <- depNames<1>, size(d.deps) == 0 || size([ e | e:employee(_,_) <- d.empls]) == 0)
		errors = errors + error(d@at, "Department should have at least one employee or sub-department");
		
	// Check 6: Each employee has a unique name
	empNames = { < e.name, e > | / e:employee(_,_) <- cs };
	if (ename <- empNames<0>, size(empNames[ename]) > 1)
		errors = errors + { error(e@at, "Employee name occurs more than once") | e <- empNames[empName] };
		
	// Check 7: Additional properties: salary and possibly others
	// TODO: Add check here...
	
	// Check 8: Each employee serves in only one position in the company
	empNameRel = { <e.name, d> | <e,d> <- getEmpDepRel(c) };
	errors += { e + " serves in multiple positions" | e <- empNameRel<0>, size(empNameRel[e]) > 1 }; 

	// Check 9: Managers are employees, too
	managers = { m | / m:manager(_) <- cs };
	for (m <- managers, m.emp notin empNames<1>)
		errors = errors + error(m@at, "Manager does not occur separately as an employee");
		
	return errors;
}

public rel[Employee, list[Department]] getEmpDepRel(Company c) {
	set[list[Department]] deps = { [d] | d <- c.departments };
	solve(deps)
		deps = deps + { d + [s] | d <- deps, s <- last(d).subDepartments };
	return { s | d <- deps, s := { <e, d> | e <- last(d).employees } + {<last(d).manager.employee, d>} };
}

