# unicode-encodings

[***C functions of encode/decode utf-16***](https://unicodebook.readthedocs.io/unicode_encodings.html)

```cpp
#include <stdint.h>

void
encode_utf16_pair(uint32_t character, uint16_t *units)
{
    unsigned int code;
    assert(0x10000 <= character && character <= 0x10FFFF);
    code = (character - 0x10000);
    units[0] = 0xD800 | (code >> 10);
    units[1] = 0xDC00 | (code & 0x3FF);
}

uint32_t
decode_utf16_pair(uint16_t *units)
{
    uint32_t code;
    assert(0xD800 <= units[0] && units[0] <= 0xDBFF);
    assert(0xDC00 <= units[1] && units[1] <= 0xDFFF);
    code = 0x10000;
    code += (units[0] & 0x03FF) << 10;
    code += (units[1] & 0x03FF);
    return code;
}
```
