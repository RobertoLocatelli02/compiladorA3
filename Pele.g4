grammar Pele;

@header {
import org.antlr.v4.runtime.*;
import java.util.*;
}

// Ações semânticas
@members {
  Pele pele = new Pele();
}

// Definição das regras sintáticas
program: start statement* end {pele.writeCode();};

start: 'inicio' {pele.printInicio();};

statement:
    assignment
    | variableDeclaration
    | ifStatement
    | loopStatement
    | scanfStatement
    | printStatement
    | incrementVariable
    | decrementVariable;

variableDeclaration: type=('int' | 'float' | 'string') id=ID '=' mathExpression ';' {pele.declararVariavel($id.getText(), $type.getText());};

assignment: id=ID '=' mathExpression ';' {pele.atribuirVariavel($id.getText());};

mathExpression:
    (value=INT | value=DECIMAL | value=STRING | id=ID) {pele.adicionaBuffer($value != null ? $value.getText() : $id.getText());}
    (op=OPMATH {pele.adicionaBuffer($op.getText());}
    (value=INT | value=DECIMAL | value=STRING | id=ID) {pele.adicionaBuffer($value != null ? $value.getText() : $id.getText());})*;

logicExpression:
    (value=INT | value=DECIMAL | value=STRING | id=ID) {pele.code += $value != null ? $value.getText() : $id.getText();}
    op=OPREL {pele.code += $op.getText();}
    (value=INT | value=DECIMAL | value=STRING | id=ID) {pele.code += $value != null ? $value.getText() : $id.getText();};

incrementVariable: id=ID '++;' {pele.incrementaVariavel($id.getText());};

decrementVariable: id=ID '--;' {pele.decrementaVariavel($id.getText());};

end: 'fim' {pele.printFim();};

ifStatement: 'se' '(' {pele.code += "\nif(";} logicExpression ')' {pele.code += ")\n";} block ('senao' {pele.code += "else\n";} block)?;

loopStatement: whileStatement | doWhileStatement ;

whileStatement: 'enquanto' '(' {pele.code += "\nwhile(";} logicExpression ')' {pele.code += ")";} block;

doWhileStatement: 'fazer' {pele.code += "\ndo";} block 'enquanto' '(' {pele.code += "while(";} logicExpression ')' ';' {pele.code += ");";};

block: '{' {pele.printAC();} statement* '}' {pele.printFC();};

scanfStatement: 'ler' '(' id=ID ',' question=STRING ')' ';' {pele.lerUserInput($id.getText(), $question.getText());};

printStatement:
    'escrever' '(' (id=ID | str=STRING) ')' ';' {pele.printString($id != null ? $id.getText() : $str.getText());};

// Definição dos tokens léxicos
ID: [a-zA-Z][a-zA-Z0-9_]*;
INT: [0-9]+;
DECIMAL: [0-9]+ '.' [0-9]+;
STRING: '"' ~["\r\n]* '"';
OPREL: '>' | '<' | '>=' | '<=' | '==' | '!=';
WS: [ \t\r\n]+ -> skip;
OPMATH: '+' | '-' | '*' | '/';
AND: '&&';
OR: '||';
