Start = _ object:Object _ { return object; }

Object = '{' _ propertyList:PropertyList? _ '}' { return propertyList; }

VariableName = $ ([A-Za-z_] / Digit)+
Value = String / Number / Undefined / Null / Boolean / Object / Array

PropertyList = first:Property other:PropertyWithPrependComma* _ ','? {
	const obj = {};
    if (first)
    	obj[first.key] = first.value;
    if (other) {
        if (Array.isArray(other))
        	other.forEach(e => obj[e.key] = e.value);
        else obj[other.key] = other.value;
    }
    return obj;
}
PropertyWithPrependComma = _ ',' _ property:Property { return property; }
Property = key:PropertyName _ ':' _ value:Value { return { 'key': key, 'value': value }; }
PropertyName = String / VariableName

Array = '[' _ items:ArrayItemList? _ ']' { return items; }
ArrayItemList = first:Value other:ValueWithPrependComma* _ ','? {
	const arr = [];
    if (first)
    	arr.push(first);
    if (other) {
        if (Array.isArray(other))
        	arr.push(...other);
        else arr.push(other);
    }
    return arr;
}
ValueWithPrependComma = _ ',' _ value:Value { return value; }

Undefined = 'undefined' { return undefined; }
Null = 'null' { return null; }

Boolean = True / False
True = 'true' { return true; }
False = 'false' { return false; }

String = Doublequote content:$ DoublequoteChar* Doublequote { return content; }
	     / Singlequote content:$ SinglequoteChar* Singlequote { return content; }
	     / Backtick content:$ BacktickChar* Backtick { return content; }
DoublequoteChar = Backslash Doublequote
     / Backslash Backslash
     / Backslash [bfnrt]
     / Backslash 'u' Hex Hex Hex Hex
     / (!Doublequote .)
SinglequoteChar = Backslash Singlequote
     / Backslash Backslash
     / Backslash [bfnrt]
     / Backslash 'u' Hex Hex Hex Hex
     / (!Singlequote .)
BacktickChar = Backslash Backtick
     / Backslash Backslash
     / Backslash [bfnrt]
     / Backslash 'u' Hex Hex Hex Hex
     / (!Backtick .)

Number = integer:$Digit+ decimal:$('.' $Digit*)? { return Number(integer + (decimal || '')) }
Digit = [0-9]
Hex = [0-9A-Fa-f]

Doublequote = '"'
Singlequote = '\''
Backtick = '`'
Backslash = '\\'

_ "whitespace" = $ [ \t\r\n]*