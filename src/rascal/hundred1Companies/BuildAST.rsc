module rascal::hundred1Companies::BuildAST

import String;
import ParseTree;

import rascal::hundred1Companies::Grammar;
import rascal::hundred1Companies::AST;

public Companies buildAST(S_Companies sc) {
	Company toAST(S_Company c) {
		if (`company <S_StringLiteral name> { <S_Department* departments> }` := c)
			return company("<name>", [ toAST(d) | d <- departments ])[@at=c@\loc];
		throw "Unrecognized S_Company syntax: <sc>";
	}
	
	Department toAST(S_Department d) {
		if (`department <S_StringLiteral name> { <S_DepartmentElement* elements> }` := d) {
			list[Department] dl = [ ];
			list[Employee] el = [ ];
			for (e <- elements) {
				switch(e) {
					case (S_DepartmentElement) `<S_Department ded>` : dl = dl + toAST(ded);
					case (S_DepartmentElement) `<S_Manager dem>` : el = el + toAST(dem);
					case (S_DepartmentElement) `<S_Employee dee>` : el = el + toAST(dee);
					default : throw "Unrecognized S_DepartmentElement syntax: <e>";
				}	
			}
			return department("<name>", dl, el)[@at=d@\loc];
		}
		throw "Unrecognized S_Department syntax: <d>";
	}
	
	Employee toAST(S_Manager m) {
		if (`manager <S_StringLiteral name> { <S_EmployeeProperty* properties> }` := m)
			return manager(employee("<name>", [ toAST(p) | p <- properties ]))[@at=m@\loc];
		throw "Unrecognized S_Manager syntax: <m>";
	}
	
	Employee toAST(S_Employee e) {
		if (`employee <S_StringLiteral name> { <S_EmployeeProperty* properties> }` := e)
			return employee("<name>", [ toAST(p) | p <- properties ])[@at=e@\loc];	
		throw "Unrecognized S_Employee syntax: <e>";
	}
	
	EmployeeProperty toAST(S_EmployeeProperty ep) {
		if (`<S_Identifier name> <S_Literal val>` := ep) {
			switch(val) {
				case (S_Literal)`<S_StringLiteral slit>` : return strProp("<name>", "<slit>")[@at=ep@\loc];
				case (S_Literal)`<S_IntegerLiteral ilit>` : return intProp("<name>", toInt("<ilit>"))[@at=ep@\loc];
				default : throw "Unrecognized S_Literal syntax: <val>"; 
			}
		}
		throw "Unrecognized S_EmployeeProperty syntax: <ep>";
	}
	
	return companies([ toAST(c) | c <- sc.companies ]);
}