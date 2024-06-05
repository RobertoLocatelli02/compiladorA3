grammar Expr;

@header {
    import org.antlr.v4.runtime.*;
    import java.util.*;
}

// Ações semânticas
@members {
    Compilador compilador = new Compilador();
}

// Definição das regras sintáticas
program: start statement* end {compilador.escreverCodigo();};

start: 'inicio' {compilador.printInicio();};

statement:
    assignment
    | variableDeclaration
    | ifStatement
    | loopStatement
    | scanfStatement
    | printStatement
    | incrementVariable
    | decrementVariable;

variableDeclaration: type=('int' | 'float' | 'string' | 'boolean') id=ID '=' mathExpression ';' {compilador.declararVariavel($id.getText(), $type.getText());};

assignment: id=ID '=' mathExpression ';' {compilador.atribuirVariavel($id.getText());};

mathExpression:
    (value=INT | value=DECIMAL | value=STRING | value=BOOLEAN | id=ID) {compilador.adicionaBuffer($value != null ? $value.getText() : $id.getText());}
    (op=OPERADORES_MATEMATICOS {compilador.adicionaBuffer($op.getText());}
    (value=INT | value=DECIMAL | value=STRING | value=BOOLEAN | id=ID) {compilador.adicionaBuffer($value != null ? $value.getText() : $id.getText());})*;

logicExpression:
    (value=INT | value=DECIMAL | value=STRING | value=BOOLEAN | id=ID) {compilador.code += $value != null ? $value.getText() : $id.getText();}
    op=OPERADORES_LOGICOS {compilador.code += $op.getText();}
    (value=INT | value=DECIMAL | value=STRING | value=BOOLEAN | id=ID) {compilador.code += $value != null ? $value.getText() : $id.getText();};

incrementVariable: id=ID '++;' {compilador.incrementaVariavel($id.getText());};

decrementVariable: id=ID '--;' {compilador.decrementaVariavel($id.getText());};

end: 'fim' {compilador.printFim();};

ifStatement: 'se' '(' {compilador.code += "\nif(";} logicExpression ')' {compilador.code += ")\n";} block ('senao' {compilador.code += "else\n";} block)?;

loopStatement: whileStatement | doWhileStatement ;

whileStatement: 'enquanto' '(' {compilador.code += "\nwhile(";} logicExpression ')' {compilador.code += ")";} block;

doWhileStatement: 'fazer' {compilador.code += "\ndo";} block 'enquanto' '(' {compilador.code += "while(";} logicExpression ')' ';' {compilador.code += ");";};

block: '{' {compilador.printAbreEscopo();} statement* '}' {compilador.printFechaEscopo();};

scanfStatement: 'ler' '(' id=ID ',' question=STRING ')' ';' {compilador.lerUserInput($id.getText(), $question.getText());};

printStatement:
    'escrever' '(' (id=ID | str=STRING) ')' ';' {compilador.printString($id != null ? $id.getText() : $str.getText());};

// Definição dos tokens léxicos
ID: [a-zA-Z][a-zA-Z0-9_]*;
INT: [0-9]+;
DECIMAL: [0-9]+ '.' [0-9]+;
BOOLEAN: 'verdadeiro' | 'falso';
STRING: '"' ~["\r\n]* '"';
OPERADORES_LOGICOS: '>' | '<' | '>=' | '<=' | '==' | '!=';
WS: [ \t\r\n]+ -> skip;
OPERADORES_MATEMATICOS: '+' | '-' | '*' | '/';
AND: '&&';
OR: '||';
