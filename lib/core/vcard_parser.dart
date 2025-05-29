
class VcardParser {
  final VCARD_BEGIN_SIGN      = 'BEGIN:VCARD';
  final VCARD_END_SIGN        = 'END:VCARD';
  final VCARD_FIELD_SEPARATORS = [';', '='];
  final VCARD_TAG_SEPARATOR = '\n';
  final VCARD_TAG_KE_VALUE_SEPARATOR = ':';
  final List<String> VCARD_TAG_VALUE_IGONE_SEPARATOR = [',', ' '];
  final VCARD_TAGS = [
    'ADR',
    'AGENT',
    'BDAY',
    'CATEGORIES',
    'CLASS',
    'EMAIL',
    'FN',
    'GEO',
    'IMPP',
    'KEY',
    'LABEL',
    'LOGO',
    'MAILER',
    'N',
    'NAME',
    'NICKNAME',
    'NOTE',
    'ORG',
    'PHOTO',
    'PRODID',
    'PROFILE',
    'REV',
    'ROLE',
    'SORT-STRING'
    'SOUND',
    'SOURCE',
    'TEL',
    'TITLE',
    'TZ',
    'UID',
    'URL',
    'VERSION',
  ];

  String content = "";
  Map<String, Object> tags = new Map<String,Object>();
  VcardParser(this.content);

  Map<String, dynamic> parse() {
    Map<String,Object> tags = new Map<String, Object>();

    List<String> lines = content.replaceAll(";;", "").split(VCARD_TAG_SEPARATOR);
    lines.forEach((field) {
      String key = "";
      dynamic value;

      // Extract labels and values in each row
      List<String> tagAndValue = field.split(VCARD_TAG_KE_VALUE_SEPARATOR);
      if (tagAndValue.length != 2) {
        return ;
      }

      key = tagAndValue[0].trim();
      value = tagAndValue[1].trim().replaceAll(VCARD_TAG_VALUE_IGONE_SEPARATOR[0], VCARD_TAG_VALUE_IGONE_SEPARATOR[1]);

      // For complex fields, the data needs to be further parsed
      if (key.contains(VCARD_FIELD_SEPARATORS[0])) {
        value = parseFields(field.trim());
      }

      // Add or merge data
      if(tags.containsKey(key)) {
        List<Map<String,Object>> oldValues = <Map<String,Object>>[];
        // Save old and new data with List if not merged before
        if(tags[key] is Map) {
          Map<String,Object> oldValue = tags;
          oldValues.add(oldValue);
          oldValues.add(value);
          value = oldValues;
        } else {
          // If merged before, append new data to old data
          oldValues = tags as List<Map<String, Object>>;
          oldValues.add(value);
          value = oldValues;
        }
      }
      // Add the parsed field to tags
      tags[key] = value;
    });

    this.tags = tags;
    return tags;
  }

  /*
    解析字段
   */
  Object parseFields(String line) {
    Object field = new Object();
    List<String> rawFields = line.split(VCARD_FIELD_SEPARATORS[0]);

    // 切分得到的原始字段中，第0个元素便是key，因此忽略
    rawFields.getRange(1, rawFields.length).forEach((rawField) {
        List<String> items = <String>[];
        List<String> rawItems = rawField.split(VCARD_FIELD_SEPARATORS[0]);
        if(rawItems.length == 1) {
          rawItems = rawField.split(VCARD_FIELD_SEPARATORS[1]);
        }

        // 提取item的key和value
        if(rawItems.isNotEmpty) {
          rawItems.forEach((itemValue) {
            items = itemValue.split(VCARD_TAG_KE_VALUE_SEPARATOR);
          });
        }

        // item的key和value保存在数组，因此其元素数量为2
        if (items.length == 2) {
          field = {'name': items.elementAt(0), 'value': items.elementAt(1).replaceAll(VCARD_TAG_VALUE_IGONE_SEPARATOR[0], VCARD_TAG_VALUE_IGONE_SEPARATOR[1])};
        }
      });
      return field;
  }

  /*
    序列化
   */
  String serialize() {
    String result = '';
    tags.forEach((tag, value) {
      if (VCARD_TAGS.contains(tag)) {
       String matchTag = VCARD_TAGS.firstWhere((key){
         return tag.contains(key);
       });

       result = result + matchTag + VCARD_TAG_KE_VALUE_SEPARATOR + value.toString() + VCARD_TAG_SEPARATOR;
           }
    });

    result = VCARD_BEGIN_SIGN + VCARD_TAG_SEPARATOR + result + VCARD_BEGIN_SIGN;
    return result;
  }
}
