module rascal::hundred1Companies::Example

import rascal::hundred1Companies::AST;

public Company exampleCompany = 
	company("meganalysis", {
		department("Research", manager(employee("Craig", "Redmond", 123456)), {}, {
			employee("Erik", "Utrecht", 12345)
		}),
		department("Development", manager(employee("Ray", "Redmond", 234567)), {
			department("Dev1", manager(employee("Chuck", "Redmond", 12345)), {}, {}),
			department("Dev2", manager(employee("Barry", "Redmond", 12345)), {}, {})
		}, {})
	}
);