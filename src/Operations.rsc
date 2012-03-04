@license{
  Copyright (c) 2009-2011 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Bas Basten - Bas.Basten@cwi.nl (CWI)}
@contributor{Mark Hills - Mark.Hills@cwi.nl (CWI)}
module Operations

import AST;

public Company cut(Company c) {
	return visit (c) {
		case employee(name, address, salary) => employee(name, address, salary / 2)
	}
}

public int total(Company c) {
	return (0 | it + salary | /employee(name, address, salary) <- c);
}