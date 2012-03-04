module rascal::hundred1Companies::AST

anno loc Company@at;
anno loc Department@at;
anno loc Employee@at;
anno loc EmployeeProperty@at;

data Companies 
	= companies(list[Company] comps)
	;

data Company 
	= company(str name, list[Department] deps)
	;

data Department 
	= department(str name, list[Department] deps, list[Employee] empls)
	;

data Employee 
	= employee(str name, list[EmployeeProperty] props)
	;

data Employee 
	= manager(Employee emp)
	;

data EmployeeProperty 
	= intProp(str name, int intVal)
	| strProp(str name, str strVal)
	;
