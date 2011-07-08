module rascal::hundred1Companies::Grammar

/*
company "meganalysis" {
  department "Research" {
    manager "Craig" {
      address "Redmond"
      salary 123456
    }
    employee "Erik" {
      address "Utrecht"
      salary 12345
    }
    ...
  }
  department "Development" {
    manager "Ray" {
      address "Redmond"
      salary 234567
    }
    department "Dev1" { ... }
    department "Dev2" { ... }
  }
}
*/
start syntax S_Companies = S_Company+ companies;

syntax S_Company
	= "company" S_StringLiteral name "{" S_Department* departments "}"
	;

syntax S_Department
	= "department" S_StringLiteral name "{" S_DepartmentElement* elements "}"
	;
	
syntax S_DepartmentElement
	= S_Department
	| S_Manager
	| S_Employee
	;

syntax S_Manager
	= "manager" S_StringLiteral name "{" S_EmployeeProperty* properties "}"
	;
	
syntax S_Employee
	= "employee" S_StringLiteral name "{" S_EmployeeProperty* properties "}"
	; 

syntax S_EmployeeProperty
	= S_Identifier name S_Literal val
	;
	
lexical S_Identifier
	=  ([A-Z a-z _] !<< [A-Z _ a-z] [0-9 A-Z _ a-z]* !>> [0-9 A-Z _ a-z]) \ S_Keywords 
	;

keyword S_Keywords
	= "company"
	| "department"
	| "manager"
	| "employee"
	;
	 	
syntax S_Literal
	= S_StringLiteral stringLiteral
	| S_IntegerLiteral integerLiteral
	;

lexical S_StringLiteral
	= @category="Constant" "\"" (![\"])* "\"" 
	;

lexical S_IntegerLiteral
	= @category="Constant" [0-9]+ !>> [0-9]
	;
	
lexical Layout 
	= [\t-\n\r\ ]
	;

layout Layouts
	= Layout* !>> [\t-\n \r \ ]
	;
