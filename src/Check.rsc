@license{
  Copyright (c) 2009-2011 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Bas Basten - Bas.Basten@cwi.nl (CWI)}
@contributor{Mark Hills - Mark.Hills@cwi.nl (CWI)}
module Check

import ParseTree;
import Grammar;
import AST;
import BuildAST;
import Verify;

public S_Companies checkCompanies(S_Companies sc) {
	c = buildAST(sc);
	msgs = verify(c);
	return sc[@messages = msgs];
}
