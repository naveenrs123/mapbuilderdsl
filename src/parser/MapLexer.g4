lexer grammar MapLexer;

/** ignore white space during tokenization */
WS: [\r\n\t ]+ -> channel(HIDDEN);


/** map */
MAP_SECTION_START: '#start map';
MAP_CREATE_START: 'CREATE MAP' -> mode(QUOTED_TEXT_MODE);
MAP_OR_REGION_DIMENSIONS: 'WITH DIMENSIONS' -> mode(TUPLE_MODE);
MAP_CREATE_COLOUR: 'WITH COLOR' -> mode(COLOR_MODE);
MAP_SECTION_END: '#end map';


/** def */
DEF_SECTION_START: '#start definitions';
DEF_SECTION_END: '#end definitions';
// function
FUNCTION_SIGNATURE_START: 'DEFINE FUNCTION' -> mode(TEXT_MODE);
FUNCTION_PARAM_START: '(' -> mode(TEXT_MODE);
FUNCTION_PARAM_SEP: ',' -> mode(TEXT_MODE);
FUNCTION_PARAM_END: '):' -> mode(FUNCTION_STATEMENT_MODE);
// define feature
DEFINE_FEATURE_START: 'DEFINE FEATURE' -> mode(TEXT_MODE);
DEFINE_FEATURE_ICON: 'WITH ICON' -> mode(QUOTED_TEXT_MODE);
DEFINE_FEATURE_SIZE: 'WITH SIZE' -> mode(NUM_MODE);


/** place and call */
PLACE_AND_CALL_START: '#start place and call';
PLACE_AND_CALL_END: '#end place and call';
// define feature (use above tokens)
// place feature
PLACE_FEATURE_START: 'PLACE FEATURE' -> mode(TEXT_MODE);
FEATURE_OR_REGION_NAME: 'WITH NAME' -> mode(QUOTED_TEXT_MODE);
FEATURE_OR_REGION_LOCATION: 'WITH LOCATION' -> mode(TUPLE_MODE);
PLACE_FEATURE_ON: 'ON' -> mode(AREA_MODE);
FEATURE_OR_REGION_DISPLAY: 'DISPLAY NAME' -> mode(BOOLEAN_MODE);
// place region (other tokens shared with place feature and create map)
PLACE_REGION_START: 'PLACE REGION' -> mode(REGION_MODE);
// function call
FUNCTION_CALL_START: 'CALL FUNCTION' -> mode(TEXT_MODE);
FUNCTION_CALL_PARAM_END: ')';
PLACE_STATEMENT_END: ';';


/** other modes */
mode TEXT_MODE;
TEXT: [a-zA-Z0-9_]+ -> mode(DEFAULT_MODE);
WS_TEXT: [\r\n\t ]+ -> channel(HIDDEN);

mode QUOTED_TEXT_MODE;
WS_TEXT_QUOTED_TEXT_MODE: [\r\n\t ]+ -> channel(HIDDEN);
OPENING_QUOTE: '{';
QUOTED_TEXT: [a-zA-Z0-9][a-zA-Z0-9 ]* -> mode(QUOTED_TEXT_MODE);
CLOSING_QUOTE: '}' -> mode(DEFAULT_MODE);

//mode QUOTED_TEXT_MODE_TEXT;
//QUOTED_TEXT: [a-zA-Z0-9 ]+ -> mode(QUOTED_TEXT_MODE);


mode NUM_MODE;
NUM: [0-9]+ -> mode(DEFAULT_MODE);
WS_NUM: [\r\n\t ]+ -> channel(HIDDEN);

mode TUPLE_MODE;
WS_TUPLE: [\r\n\t ]+ -> channel(HIDDEN);
OPENING_BRACKET: '[';
TUPLE_TEXT: [a-zA-Z0-9]+;
TUPLE_SEP: ',' | ', ';
CLOSING_BRACKET: ']' -> mode(DEFAULT_MODE);

mode COLOR_MODE;
COLOR_START: '#';
COLOR_CODE: [0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F];
COLOR_END: ';' -> mode(DEFAULT_MODE);
WS_COLOR: [\r\n\t ]+ -> channel(HIDDEN);

mode REGION_MODE;
REGION: ('grass' | 'desert' | 'forest' | 'water' | 'snow' | 'ocean') -> mode(DEFAULT_MODE);
WS_REGION: [\r\n\t ]+ -> channel(HIDDEN);

mode AREA_MODE;
AREA_MAP: 'map' -> mode(DEFAULT_MODE);
AREA_REGION: 'region' -> mode(QUOTED_TEXT_MODE);
WS_AREA: [\r\n\t ]+ -> channel(HIDDEN);

mode BOOLEAN_MODE;
WS_BOOLEAN: [\r\n\t ]+ -> channel(HIDDEN);
BOOLEAN_START: '%';
BOOLEAN_TRUE: 'TRUE' -> mode(DEFAULT_MODE);
BOOLEAN_FALSE: 'FALSE' -> mode(DEFAULT_MODE);

mode FUNCTION_STATEMENT_MODE;
WS_FUNCTION_STATEMENT: [\r\n\t ]+ -> channel(HIDDEN);
FUNCTION_STATEMENT_NUM: [0-9]+;
SIGNATURE_END: ':';
FUNCTION_STATEMENT_END_OF_LINE: ';';
FUNCTION_SIGNATURE_END: 'END FUNCTION;' -> mode(DEFAULT_MODE);
// loop
LOOP_START: 'START LOOP' -> mode(FUNCTION_STATEMENT_TEXT_MODE);
LOOP_END: 'END LOOP' -> mode(FUNCTION_STATEMENT_TEXT_MODE);
LOOP_TEXT_SEP: ',' -> mode(FUNCTION_STATEMENT_TEXT_MODE);
LOOP_FROM: 'FROM' -> mode(FUNCTION_STATEMENT_TEXT_MODE);
LOOP_TO: 'TO' -> mode(FUNCTION_STATEMENT_TEXT_MODE);
LOOP_INCREMENT: 'INCREMENT BY';
LOOP_DECREMENT: 'DECREMENT BY';
// conditional
IF_SIGNATURE_START: '$IF' -> mode(COMPARISON_FROM_IF_MODE);
IF_END: '$END IF;';
ELSE_START: '$ELSE:' ;
ELSE_END: '$END ELSE;';
// place feature
PLACE_FEATURE_START_FROM_FUNC: 'PLACE FEATURE' -> mode(FUNCTION_STATEMENT_TEXT_MODE);
FEATURE_OR_REGION_NAME_FROM_FUNC: 'WITH NAME' -> mode(FROM_FUNC_QUOTED_TEXT_MODE);
FEATURE_OR_REGION_LOCATION_FROM_FUNC: 'WITH LOCATION' -> mode(FROM_FUNC_TUPLE_MODE);
PLACE_FEATURE_ON_FROM_FUNC: 'ON' -> mode(AREA_FROM_FUNC_MODE);
FEATURE_OR_REGION_DISPLAY_FROM_FUNC: 'DISPLAY NAME' -> mode(BOOLEAN_FROM_FUNC_MODE);
// place region
PLACE_REGION_START_FROM_FUNC: 'PLACE REGION' -> mode(PLACE_REGION_FROM_FUNC_MODE);
PLACE_REGION_DIMENSIONS: 'WITH DIMENSIONS' -> mode(FROM_FUNC_TUPLE_MODE);
// assignment
ASSIGNMENT_START: '%assign' -> mode(FUNCTION_STATEMENT_TEXT_MODE);
ASSIGNMENT_EQUALS: '=' -> mode(EXPRESSION_MODE);


mode FUNCTION_STATEMENT_TEXT_MODE;
WS_FUNCTION_STATEMENT_TEXT: [\r\n\t ]+ -> channel(HIDDEN);
FUNCTION_STATEMENT_TEXT_TEXT: [a-zA-Z0-9_]+ -> mode(FUNCTION_STATEMENT_MODE);

/** place feature helpers */
mode FROM_FUNC_QUOTED_TEXT_MODE;
WS_FROM_FUNC_QUOTED_TEXT_MODE: [\r\n\t ]+ -> channel(HIDDEN);
FROM_FUNC_OPENING_QUOTE: '{';
FROM_FUNC_QUOTED_TEXT: [a-zA-Z0-9][a-zA-Z0-9 ]*;
FROM_FUNC_CLOSING_QUOTE: '}' -> mode(FUNCTION_STATEMENT_MODE);

mode FROM_FUNC_TUPLE_MODE;
WS_FROM_FUNC_TUPLE: [\r\n\t ]+ -> channel(HIDDEN);
FROM_FUNC_OPENING_BRACKET: '[';
FROM_FUNC_TUPLE_TEXT: [a-zA-Z0-9]+;
FROM_FUNC_TUPLE_SEP: ',';
FROM_FUNC_CLOSING_BRACKET: ']' -> mode(FUNCTION_STATEMENT_MODE);

mode AREA_FROM_FUNC_MODE;
WS_AREA_FROM_FUNC: [\r\n\t ]+ -> channel(HIDDEN);
AREA_FROM_FUNC_MAP: 'map' -> mode(FUNCTION_STATEMENT_MODE);
AREA_FRM_FUNC_REGION: 'region' -> mode(FROM_FUNC_QUOTED_TEXT_MODE);

mode BOOLEAN_FROM_FUNC_MODE;
WS_BOOLEAN_FROM_FUNC: [\r\n\t ]+ -> channel(HIDDEN);
BOOLEAN_FROM_FUNC_START: '%';
BOOLEAN_FROM_FUNC_TRUE: 'TRUE' -> mode(FUNCTION_STATEMENT_MODE);
BOOLEAN_FROM_FUNC_FALSE: 'FALSE' -> mode(FUNCTION_STATEMENT_MODE);

/** place region helpers */
mode PLACE_REGION_FROM_FUNC_MODE;
WS_PLACE_REGION_FROM_FUNC: [\r\n\t ]+ -> channel(HIDDEN);
REGION_FROM_FUNC: ('grass' | 'desert' | 'forest' | 'water' | 'snow' | 'ocean') -> mode(FUNCTION_STATEMENT_MODE);

/** assignment helpers */
mode EXPRESSION_MODE;
WS_EXPRESSION: [\r\n\t ]+ -> channel(HIDDEN);
EXPRESSION_END: ';' -> mode(FUNCTION_STATEMENT_MODE);
// comparison
MATH_COMPARE_START: '#math compare' -> mode(MATH_FROM_EXPRESSION_MODE);
MATH_COMPARE_COMPARISON_OP: ('>' | '<' | '<=' | '>=' | '==' | '!=') -> mode(MATH_FROM_EXPRESSION_MODE);
QUOTE_COMPARE_START: '#text compare {' -> mode(QUOTE_COMPARE_FROM_EXPRESSION_MODE);
// math
MATH_START: '$math' -> mode(MATH_FROM_EXPRESSION_MODE);
// quoted text
QUOTE_TEXT_START: '{' -> mode (EXPRESSION_QUOTED_TEXT_MODE_FOR_VAR);
// text
EXPRESSION_TEXT: [a-zA-Z0-9_]+;
// boolean
BOOLEAN_FROM_EXPRESSION_START: '%' -> mode(BOOLEAN_FROM_EXPRESSION_MODE);

mode EXPRESSION_QUOTED_TEXT_MODE_FOR_VAR;
WS_EXPRESSION_QUOTED_TEXT_FOR_VAR: [\r\n\t ]+ -> channel(HIDDEN);
EXPRESSION_OPENING_QUOTE_FOR_VAR: '{';
EXPRESSION_QUOTED_TEXT_FOR_VAR: [a-zA-Z0-9][a-zA-Z0-9 ]*;
EXPRESSION_CLOSING_QUOTE_FOR_VAR: '}' -> mode(EXPRESSION_MODE);

mode EXPRESSION_QUOTED_TEXT_MODE;
WS_EXPRESSION_QUOTED_TEXT: [\r\n\t ]+ -> channel(HIDDEN);
EXPRESSION_OPENING_QUOTE: '{';
EXPRESSION_QUOTED_TEXT: [a-zA-Z0-9 ]+;
EXPRESSION_CLOSING_QUOTE: '}' -> mode(FUNCTION_STATEMENT_MODE);

mode MATH_FROM_EXPRESSION_MODE;
WS_MATH_FROM_EXPRESSION: [\r\n\t ]+ -> channel(HIDDEN);
MATH_FROM_EXPRESSION_START: '$math';
MATH_FROM_EXPRESSION_TEXT: [a-zA-Z0-9_]+;
MATH_FROM_EXPRESSION_OPERATORS: '+' | '-' | '/' | '*';
MATH_FROM_EXPRESSION_END: '$end_math' -> mode(EXPRESSION_MODE);

mode QUOTE_COMPARE_FROM_EXPRESSION_MODE;
WS_QUOTE_COMPARE_FROM_EXPRESSION: [\r\n\t ]+ -> channel(HIDDEN);
QUOTE_COMPARE_FROM_EXPRESSION_QUOTED_TEXT: [a-zA-Z0-9 ]+;
QUOTE_COMPARE_FROM_EXPRESSION_CLOSING_QUOTE: '}' -> mode(SECOND_QUOTE_COMPARE_FROM_EXPRESSION_MODE);

mode SECOND_QUOTE_COMPARE_FROM_EXPRESSION_MODE;
WS_SECOND_QUOTE_COMPARE_FROM_EXPRESSION: [\r\n\t ]+ -> channel(HIDDEN);
QUOTE_COMPARISON_OP_FROM_EXPRESSION: '==' | '!=';
SECOND_QUOTE_COMPARE_FROM_EXPRESSION_OPENING_QUOTE: '{';
SECOND_QUOTE_COMPARE_FROM_EXPRESSION_QUOTED_TEXT: [a-zA-Z0-9 ]+;
SECOND_QUOTE_COMPARE_FROM_EXPRESSION_CLOSING_QUOTE: '}' -> mode(EXPRESSION_MODE);

mode BOOLEAN_FROM_EXPRESSION_MODE;
WS_BOOLEAN_FROM_EXPRESSION: [\r\n\t ]+ -> channel(HIDDEN);
BOOLEAN_FROM_EXPRESSION_TRUE: 'TRUE' -> mode(EXPRESSION_MODE);
BOOLEAN_FROM_EXPRESSION_FALSE: 'FALSE' -> mode(EXPRESSION_MODE);

/** comparison helpers */
mode COMPARISON_FROM_IF_MODE;
WS_COMPARISON: [\r\n\t ]+ -> channel(HIDDEN);
MATH_COMPARE_FROM_IF_START: '#math compare' -> mode(MATH_FROM_IF_MODE);
MATH_COMPARE_FROM_IF_COMPARISON_OP: ('>' | '<' | '<=' | '>=' | '==' | '!=') -> mode(MATH_FROM_IF_MODE);
QUOTE_COMPARE_FROM_IF_START: '#text compare {' -> mode(QUOTE_COMPARE_FROM_IF_MODE);
COMPARISON_FROM_IF_END: ':' -> mode(FUNCTION_STATEMENT_MODE);

mode MATH_FROM_IF_MODE;
WS_MATH_FROM_IF: [\r\n\t ]+ -> channel(HIDDEN);
MATH_FROM_IF_START: '$math';
MATH_FROM_IF_TEXT: [a-zA-Z0-9_]+;
MATH_FROM_IF_OPERATORS: '+' | '-' | '/' | '*';
MATH_FROM_IF_END: '$end_math' -> mode(COMPARISON_FROM_IF_MODE);

mode QUOTE_COMPARE_FROM_IF_MODE;
WS_QUOTE_COMPARE_FROM_IF: [\r\n\t ]+ -> channel(HIDDEN);
QUOTE_COMPARE_FROM_IF_QUOTED_TEXT: [a-zA-Z0-9 ]+;
QUOTE_COMPARE_FROM_IF_CLOSING_QUOTE: '}' -> mode(SECOND_QUOTE_COMPARE_FROM_IF_MODE);

mode SECOND_QUOTE_COMPARE_FROM_IF_MODE;
WS_SECOND_QUOTE_COMPARE_FROM_IF: [\r\n\t ]+ -> channel(HIDDEN);
QUOTE_COMPARISON_OP_FROM_IF: '==' | '!=';
SECOND_QUOTE_COMPARE_FROM_IF_OPENING_QUOTE: '{';
SECOND_QUOTE_COMPARE_FROM_IF_QUOTED_TEXT: [a-zA-Z0-9 ]+;
SECOND_QUOTE_COMPARE_FROM_IF_CLOSING_QUOTE: '}' -> mode(COMPARISON_FROM_IF_MODE);
