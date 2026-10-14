/// ISO 3166 alpha-2 code and endonym for each catalogue country, keyed by
/// [GallerySource.countryName]. The coverage search matches both, and the row
/// shows the endonym. The packages don't carry either.
const Map<String, (String iso, String native)> countryMeta =
    <String, (String, String)>{
      'Afghanistan': ('AF', 'افغانستان'),
      'Algeria': ('DZ', 'الجزائر'),
      'Armenia': ('AM', 'Հայաստան'),
      'Azerbaijan': ('AZ', 'Azərbaycan'),
      'Bahrain': ('BH', 'البحرين'),
      'Belarus': ('BY', 'Беларусь'),
      'Bolivia': ('BO', 'Bolivia'),
      'Brazil': ('BR', 'Brasil'),
      'Brunei': ('BN', 'Brunei'),
      'Burkina Faso': ('BF', 'Burkina Faso'),
      'Chile': ('CL', 'Chile'),
      'Colombia': ('CO', 'Colombia'),
      'Comoros': ('KM', 'جزر القمر'),
      'Cuba': ('CU', 'Cuba'),
      'Djibouti': ('DJ', 'جيبوتي'),
      'Eritrea': ('ER', 'ኤርትራ'),
      'Germany': ('DE', 'Deutschland'),
      'India': ('IN', 'भारत'),
      'Indonesia': ('ID', 'Indonesia'),
      'Iran': ('IR', 'ایران'),
      'Iranshahr': ('', 'ایرانشهر'),
      'Iraq': ('IQ', 'العراق'),
      'Italy': ('IT', 'Italia'),
      'Kuwait': ('KW', 'الكويت'),
      'Kyrgyzstan': ('KG', 'Кыргызстан'),
      'Laos': ('LA', 'ລາວ'),
      'Lebanon': ('LB', 'لبنان'),
      'Libya': ('LY', 'ليبيا'),
      'Malaysia': ('MY', 'Malaysia'),
      'Maldives': ('MV', 'ދިވެހިރާއްޖެ'),
      'Mali': ('ML', 'Mali'),
      'Mauritania': ('MR', 'موريتانيا'),
      'Namibia': ('NA', 'Namibia'),
      'Nicaragua': ('NI', 'Nicaragua'),
      'Niger': ('NE', 'Niger'),
      'North Korea': ('KP', '조선'),
      'South Korea': ('KR', '대한민국'),
      'Oman': ('OM', 'عُمان'),
      'Palestine': ('PS', 'فلسطين'),
      'Philippines': ('PH', 'Pilipinas'),
      'Qatar': ('QA', 'قطر'),
      'Republic of Ireland': ('IE', 'Éire'),
      'Slovenia': ('SI', 'Slovenija'),
      'Somalia': ('SO', 'Soomaaliya'),
      'Spain': ('ES', 'España'),
      'Sudan': ('SD', 'السودان'),
      'Syria': ('SY', 'سوريا'),
      'Tajikistan': ('TJ', 'Тоҷикистон'),
      'Tunisia': ('TN', 'تونس'),
      'Turkey': ('TR', 'Türkiye'),
      'United Arab Emirates': ('AE', 'الإمارات'),
      'Venezuela': ('VE', 'Venezuela'),
      'Vietnam': ('VN', 'Việt Nam'),
      'Yemen': ('YE', 'اليمن'),
      'Zimbabwe': ('ZW', 'Zimbabwe'),
    };

/// Folds the Arabic and Persian forms of ya and kaf together (ي/ی, ك/ک)
/// and lowercases, so either keyboard finds either spelling.
String normaliseQuery(String s) => s
    .toLowerCase()
    .replaceAll('ي', 'ی')
    .replaceAll('ى', 'ی')
    .replaceAll('ك', 'ک')
    .trim();
