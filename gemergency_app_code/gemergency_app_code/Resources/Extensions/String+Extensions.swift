import Foundation

extension String {
    
    static var hospitalKeywords: [String] {
        return [
            "help", "ambulance", "emergency", "hospital", "doctor", "nurse", "injured",
            "accident", "pain", "bleeding", "urgent", "door", "address", "near", "left",
            "right", "straight", "floor", "heart", "attack", "stroke", "breathing",
            "unconscious", "broken", "fracture", "burn", "fever", "cold", "allergy",
            "collapse", "severe", "shock", "pulse", "dizziness", "vomit", "child", "senior",
            "pregnant", "baby", "blood", "infection", "clinic", "sick", "medication",
            "transport", "ICU", "ER", "urgentcare", "response", "critical", "head", "dizzy",
            "помощь", "скорая", "экстренный", "больница", "врач", "медсестра", "раненый",
            "авария", "боль", "кровотечение", "срочно", "дверь", "адрес", "рядом", "налево",
            "направо", "прямо", "этаж", "сердце", "приступ", "инсульт", "дыхание",
            "без сознания", "перелом", "перелом", "ожог", "жар", "простуда", "аллергия",
            "коллапс", "тяжелый", "шок", "пульс", "головокружение", "рвота", "ребенок", "пожилой",
            "беременная", "младенец", "кровь", "инфекция", "клиника", "больной", "лекарство",
            "транспорт", "реанимация", "приемный покой", "неотложка", "реакция", "критический", "голова", "головокружение",
            "hilfe", "krankenwagen", "notfall", "krankenhaus", "arzt", "krankenschwester", "verletzt",
            "unfall", "schmerz", "blutung", "dringend", "tür", "adresse", "in der nähe", "links",
            "rechts", "geradeaus", "etage", "herz", "anfall", "schlaganfall", "atmung",
            "bewusstlos", "gebrochen", "fraktur", "verbrennung", "fieber", "erkältung", "allergie",
            "kollaps", "schwer", "schock", "puls", "schwindel", "erbrechen", "kind", "senior",
            "schwanger", "baby", "blut", "infektion", "klinik", "krank", "medikament",
            "transport", "intensivstation", "notaufnahme", "notfallversorgung", "reaktion", "kritisch", "kopf", "schwindelig",
            "ayuda", "ambulancia", "emergencia", "hospital", "doctor", "enfermera", "herido",
            "accidente", "dolor", "sangrado", "urgente", "puerta", "dirección", "cerca", "izquierda",
            "derecha", "recto", "piso", "corazón", "ataque", "derrame", "respiración",
            "inconsciente", "roto", "fractura", "quemadura", "fiebre", "resfriado", "alergia",
            "colapso", "grave", "choque", "pulso", "mareo", "vómito", "niño", "anciano",
            "embarazada", "bebé", "sangre", "infección", "clínica", "enfermo", "medicación",
            "transporte", "uci", "urgencias", "atención urgente", "respuesta", "crítico", "cabeza", "mareado",
            "aide", "ambulance", "urgence", "hôpital", "médecin", "infirmière", "blessé",
            "accident", "douleur", "saignement", "urgent", "porte", "adresse", "près", "gauche",
            "droite", "tout droit", "étage", "cœur", "crise", "avc", "respiration",
            "inconscient", "cassé", "fracture", "brûlure", "fièvre", "rhume", "allergie",
            "effondrement", "grave", "choc", "pouls", "vertige", "vomir", "enfant", "personne âgée",
            "enceinte", "bébé", "sang", "infection", "clinique", "malade", "médicament",
            "transport", "soins intensifs", "urgences", "soins urgents", "réponse", "critique", "tête", "étourdi",
            "ajuda", "ambulância", "emergência", "hospital", "médico", "enfermeira", "ferido",
            "acidente", "dor", "sangramento", "urgente", "porta", "endereço", "perto", "esquerda",
            "direita", "em frente", "andar", "coração", "ataque", "derrame", "respiração",
            "inconsciente", "quebrado", "fratura", "queimadura", "febre", "resfriado", "alergia",
            "colapso", "grave", "choque", "pulso", "tontura", "vômito", "criança", "idoso",
            "grávida", "bebê", "sangue", "infecção", "clínica", "doente", "medicação",
            "transporte", "uti", "pronto-socorro", "atendimento urgente", "resposta", "crítico", "cabeça", "tonto",
            "助けて", "救急車", "緊急", "病院", "医者", "看護師", "けが人",
            "事故", "痛み", "出血", "至急", "ドア", "住所", "近く", "左",
            "右", "まっすぐ", "階", "心臓", "発作", "脳卒中", "呼吸",
            "意識不明", "骨折", "骨折", "やけど", "熱", "風邪", "アレルギー",
            "倒れる", "重症", "ショック", "脈拍", "めまい", "嘔吐", "子供", "高齢者",
            "妊婦", "赤ちゃん", "血液", "感染", "クリニック", "病人", "薬",
            "搬送", "ICU", "救急外来", "救急診療", "反応", "重篤", "頭", "めまい",
            "救命", "救护车", "紧急", "医院", "医生", "护士", "受伤",
            "事故", "疼痛", "流血", "紧急", "门", "地址", "附近", "左边",
            "右边", "直走", "楼层", "心脏", "发作", "中风", "呼吸",
            "昏迷", "骨折", "骨折", "烧伤", "发烧", "感冒", "过敏",
            "昏倒", "严重", "休克", "脉搏", "头晕", "呕吐", "孩子", "老人",
            "怀孕", "婴儿", "血液", "感染", "诊所", "生病", "药物",
            "转运", "重症监护室", "急诊", "急救", "反应", "危急", "头", "头晕",
            "मदद", "एम्बुलेंस", "आपातकाल", "अस्पताल", "डॉक्टर", "नर्स", "घायल",
            "दुर्घटना", "दर्द", "खून बहना", "अत्यावश्यक", "दरवाज़ा", "पता", "पास", "बाएँ",
            "दाएँ", "सीधा", "मंज़िल", "दिल", "दौरा", "स्ट्रोक", "सांस",
            "बेहोश", "टूटा", "फ्रैक्चर", "जलना", "बुखार", "जुकाम", "एलर्जी",
            "गिरना", "गंभीर", "सदमा", "नब्ज़", "चक्कर", "उल्टी", "बच्चा", "वरिष्ठ",
            "गर्भवती", "शिशु", "खून", "संक्रमण", "क्लिनिक", "बीमार", "दवा",
            "परिवहन", "आईसीयू", "इमरजेंसी", "तत्काल चिकित्सा", "प्रतिक्रिया", "गंभीर", "सिर", "चक्कर",
            "مساعدة", "إسعاف", "طارئ", "مستشفى", "طبيب", "ممرضة", "مصاب",
            "حادث", "ألم", "نزيف", "عاجل", "باب", "عنوان", "قريب", "يسار",
            "يمين", "مستقيم", "طابق", "قلب", "نوبة", "سكتة دماغية", "تنفس",
            "فاقد الوعي", "مكسور", "كسر", "حروق", "حمى", "زكام", "حساسية",
            "إغماء", "حاد", "صدمة", "نبض", "دوار", "تقيؤ", "طفل", "مسن",
            "حامل", "رضيع", "دم", "عدوى", "عيادة", "مريض", "دواء",
            "نقل", "العناية المركزة", "طوارئ", "رعاية عاجلة", "استجابة", "حرج", "رأس", "دوخة"
        ]
    }
    
    static var policeKeywords: [String] {
        return [
            "crime", "robbery", "assault", "report", "theft", "suspicious", "help",
            "officer", "station", "witness", "victim", "emergency", "urgent", "arrest",
            "stolen", "gun", "weapon", "fight", "domestic", "breakin", "missing",
            "kidnap", "fraud", "identity", "carjacking", "vandalism", "disturbance",
            "traffic", "ticket", "investigation", "reporting", "safe", "danger", "call",
            "911", "backup", "evidence", "statement", "followup", "suspect", "description",
            "badge", "patrol", "safety", "alarm", "witnesses", "reporter", "license",
            "licenseplate", "harassment", "intimidation",
            "преступление", "ограбление", "нападение", "сообщение", "кража", "подозрительный", "помощь",
            "офицер", "участок", "свидетель", "жертва", "чрезвычайная", "срочно", "арест",
            "украденный", "пистолет", "оружие", "драка", "домашний", "взлом", "пропавший",
            "похищение", "мошенничество", "личность", "угон", "вандализм", "беспорядок",
            "трафик", "штраф", "расследование", "сообщающий", "безопасно", "опасность", "звонок",
            "911", "подкрепление", "доказательство", "показания", "допрос", "подозреваемый", "описание",
            "значок", "патруль", "безопасность", "сигнализация", "свидетели", "репортёр", "лицензия",
            "номер", "домогательство", "запугивание",
            "verbrechen", "raub", "überfall", "meldung", "diebstahl", "verdächtig", "hilfe",
            "beamter", "wache", "zeuge", "opfer", "notfall", "dringend", "festnahme",
            "gestohlen", "pistole", "waffe", "kampf", "häuslich", "einbruch", "vermisst",
            "entführung", "betrug", "identität", "autoraub", "vandalismus", "störung",
            "verkehr", "strafe", "ermittlung", "meldunggebend", "sicher", "gefahr", "anruf",
            "911", "verstärkung", "beweis", "aussage", "nachverfolgung", "verdächtiger", "beschreibung",
            "marke", "streife", "sicherheit", "alarm", "zeugen", "reporter", "lizenz",
            "nummernschild", "belästigung", "einschüchterung",
            "crimen", "robo", "asalto", "reporte", "hurto", "sospechoso", "ayuda",
            "oficial", "comisaría", "testigo", "víctima", "emergencia", "urgente", "arresto",
            "robado", "pistola", "arma", "pelea", "doméstico", "allanamiento", "desaparecido",
            "secuestro", "fraude", "identidad", "secuestrodeauto", "vandalismo", "disturbio",
            "tráfico", "multa", "investigación", "informante", "seguro", "peligro", "llamada",
            "911", "refuerzo", "evidencia", "declaración", "seguimiento", "sospechoso", "descripción",
            "placa", "patrulla", "seguridad", "alarma", "testigos", "reportero", "licencia",
            "matrícula", "acoso", "intimidación",
            "crime", "vol", "agression", "rapport", "vol", "suspect", "aide",
            "officier", "commissariat", "témoin", "victime", "urgence", "urgent", "arrestation",
            "volé", "pistolet", "arme", "bagarre", "domestique", "effraction", "disparu",
            "enlèvement", "fraude", "identité", "carjacking", "vandalisme", "trouble",
            "trafic", "amende", "enquête", "rapporteur", "sûr", "danger", "appel",
            "911", "renfort", "preuve", "déclaration", "suivi", "suspect", "description",
            "badge", "patrouille", "sécurité", "alarme", "témoins", "reporter", "permis",
            "plaque", "harcèlement", "intimidation",
            "crime", "roubo", "assalto", "relato", "furto", "suspeito", "ajuda",
            "oficial", "delegacia", "testemunha", "vítima", "emergência", "urgente", "prisão",
            "roubado", "arma", "arma", "briga", "doméstico", "arrombamento", "desaparecido",
            "sequestro", "fraude", "identidade", "sequestrodecarrro", "vandalismo", "distúrbio",
            "trânsito", "multa", "investigação", "relatando", "seguro", "perigo", "chamada",
            "911", "reforço", "prova", "depoimento", "acompanhamento", "suspeito", "descrição",
            "distintivo", "patrulha", "segurança", "alarme", "testemunhas", "repórter", "licença",
            "placa", "assédio", "intimidação",
            "犯罪", "強盗", "暴行", "報告", "窃盗", "不審", "助け",
            "警官", "交番", "証人", "被害者", "緊急", "至急", "逮捕",
            "盗まれた", "銃", "武器", "喧嘩", "家庭内", "侵入", "行方不明",
            "誘拐", "詐欺", "身元", "カージャック", "器物損壊", "騒動",
            "交通", "違反切符", "捜査", "通報者", "安全", "危険", "通報",
            "911", "応援", "証拠", "証言", "追跡", "容疑者", "特徴",
            "バッジ", "パトロール", "安全", "警報", "証人達", "記者", "免許",
            "ナンバープレート", "嫌がらせ", "脅迫",
            "犯罪", "抢劫", "袭击", "报告", "盗窃", "可疑", "帮助",
            "警官", "警局", "证人", "受害者", "紧急", "紧急", "逮捕",
            "被盗", "枪", "武器", "斗殴", "家庭", "入室", "失踪",
            "绑架", "诈骗", "身份", "劫车", "破坏", "骚乱",
            "交通", "罚单", "调查", "报案人", "安全", "危险", "电话",
            "911", "支援", "证据", "陈述", "跟进", "嫌疑人", "描述",
            "警徽", "巡逻", "安全", "警报", "证人", "记者", "执照",
            "车牌", "骚扰", "恐吓",
            "अपराध", "डकैती", "हमला", "रिपोर्ट", "चोरी", "संदिग्ध", "मदद",
            "पुलिसकर्मी", "थाना", "गवाह", "पीड़ित", "आपातकाल", "अत्यावश्यक", "गिरफ्तारी",
            "चुराया", "बंदूक", "हथियार", "लड़ाई", "घरेलू", "घुसपैठ", "लापता",
            "अपहरण", "धोखाधड़ी", "पहचान", "कारजैकिंग", "विध्वंस", "उपद्रव",
            "यातायात", "चालान", "जांच", "रिपोर्टिंग", "सुरक्षित", "खतरा", "कॉल",
            "911", "बैकअप", "सबूत", "बयान", "फॉलोअप", "संदिग्ध", "विवरण",
            "बिल्ला", "गश्त", "सुरक्षा", "अलार्म", "गवाह", "रिपोर्टर", "लाइसेंस",
            "नंबरप्लेट", "उत्पीड़न", "धमकी",
            "جريمة", "سرقة", "اعتداء", "تقرير", "سرقة", "مريب", "مساعدة",
            "ضابط", "مخفر", "شاهد", "ضحية", "طوارئ", "عاجل", "اعتقال",
            "مسروق", "مسدس", "سلاح", "شجار", "عائلي", "اقتحام", "مفقود",
            "خطف", "احتيال", "هوية", "سطو_سيارة", "تخريب", "إزعاج",
            "مرور", "مخالفة", "تحقيق", "مبلغ", "آمن", "خطر", "اتصال",
            "911", "دعم", "دليل", "شهادة", "متابعة", "مشتبه", "وصف",
            "شارة", "دورية", "أمان", "إنذار", "شهود", "مراسل", "رخصة",
            "لوحة", "تحرش", "تهديد"
        ]
    }
    
    static var fireKeywords: [String] {
        return [
            "fire", "smoke", "burning", "alarm", "evacuate", "help", "emergency", "flames",
            "heat", "danger", "building", "rescue", "trapped", "call", "911", "firetruck",
            "hose", "hydrant", "explosion", "sparks", "wildfire", "kitchen", "electrical",
            "short", "gas", "leak", "roof", "collapse", "sirens", "water", "extinguish",
            "burn", "injured", "evacuation", "stairs", "exit", "safe", "neighbor", "smokealarm",
            "flare", "responder", "controlled", "alarmbell", "urgent", "rescueteam", "firefighter",
            "contain", "spread", "smolder",
            "огонь", "дым", "горение", "сигнализация", "эвакуироваться", "помощь", "чрезвычайная", "пламя",
            "жара", "опасность", "здание", "спасение", "запертый", "позвонить", "911", "пожарнаямашина",
            "шланг", "гидрант", "взрыв", "искры", "леснойпожар", "кухня", "электрический",
            "короткое", "газ", "утечка", "крыша", "обрушение", "сирены", "вода", "тушить",
            "ожог", "пострадавший", "эвакуация", "лестница", "выход", "безопасно", "сосед", "дымоуловитель",
            "вспышка", "спасатель", "контролируемый", "сигнальныйколокол", "срочно", "спасательнаякоманда", "пожарный",
            "сдерживать", "распространяться", "тлеть",
            "feuer", "rauch", "brennen", "alarm", "evakuieren", "hilfe", "notfall", "flammen",
            "hitze", "gefahr", "gebäude", "rettung", "eingeschlossen", "anrufen", "112", "feuerwehrwagen",
            "schlauch", "hydrant", "explosion", "funken", "waldbrand", "küche", "elektrisch",
            "kurzschluss", "gas", "leck", "dach", "einsturz", "sirenen", "wasser", "löschen",
            "verbrennung", "verletzt", "evakuierung", "treppe", "ausgang", "sicher", "nachbar", "rauchmelder",
            "fackel", "helfer", "kontrolliert", "alarmglocke", "dringend", "rettungsteam", "feuerwehrmann",
            "eindämmen", "ausbreiten", "schwelen",
            "fuego", "humo", "ardiendo", "alarma", "evacuar", "ayuda", "emergencia", "llamas",
            "calor", "peligro", "edificio", "rescate", "atrapado", "llamar", "911", "camióndebomberos",
            "manguera", "hidrante", "explosión", "chispas", "incendioforestal", "cocina", "eléctrico",
            "cortocircuito", "gas", "fuga", "techo", "colapso", "sirenas", "agua", "apagar",
            "quemadura", "herido", "evacuación", "escaleras", "salida", "seguro", "vecino", "detectordehumo",
            "bengala", "rescatista", "controlado", "campanadearm", "urgente", "equipoderescate", "bombero",
            "contener", "propagarse", "humeante",
            "feu", "fumée", "enflammer", "alarme", "évacuer", "aide", "urgence", "flammes",
            "chaleur", "danger", "bâtiment", "sauvetage", "coincé", "appeler", "112", "camiondepompier",
            "tuyau", "borneincendie", "explosion", "étincelles", "feudeforêt", "cuisine", "électrique",
            "court-circuit", "gaz", "fuite", "toit", "effondrement", "sirènes", "eau", "éteindre",
            "brûlure", "blessé", "évacuation", "escaliers", "sortie", "sûr", "voisin", "détecteurdefumée",
            "fusée", "secouriste", "contrôlé", "clochedalarme", "urgent", "équipedesecours", "pompier",
            "contenir", "propager", "couver",
            "fogo", "fumaça", "ardendo", "alarme", "evacuar", "ajuda", "emergência", "chamas",
            "calor", "perigo", "prédio", "resgate", "preso", "ligar", "193", "caminhãodebombeiros",
            "mangueira", "hidrante", "explosão", "faíscas", "incêndioflorestal", "cozinha", "elétrico",
            "curtocircuito", "gás", "vazamento", "telhado", "colapso", "sirenes", "água", "apagar",
            "queimadura", "ferido", "evacuação", "escadas", "saída", "seguro", "vizinho", "detectordefumaça",
            "sinalizador", "socorrista", "controlado", "sinoalarme", "urgente", "equipe de resgate", "bombeiro",
            "conter", "espalhar", "fumaçando",
            "火事", "煙", "燃焼", "警報", "避難", "助け", "緊急", "炎",
            "熱", "危険", "建物", "救助", "閉じ込められた", "電話する", "119", "消防車",
            "ホース", "消火栓", "爆発", "火花", "山火事", "キッチン", "電気",
            "ショート", "ガス", "漏れ", "屋根", "崩壊", "サイレン", "水", "消す",
            "やけど", "負傷者", "避難", "階段", "出口", "安全", "隣人", "煙探知器",
            "発炎筒", "救助隊員", "制御された", "警報ベル", "緊急", "救助隊", "消防士",
            "抑える", "広がる", "くすぶる",
            "火灾", "烟", "燃烧", "警报", "疏散", "救援", "紧急", "火焰",
            "高温", "危险", "建筑", "救助", "被困", "呼叫", "119", "消防车",
            "水管", "消火栓", "爆炸", "火花", "山火", "厨房", "电气",
            "短路", "煤气", "泄漏", "屋顶", "倒塌", "警笛", "水", "灭火",
            "烧伤", "受伤", "疏散", "楼梯", "出口", "安全", "邻居", "烟雾报警器",
            "照明弹", "救援人员", "可控", "警铃", "紧急", "救援队", "消防员",
            "控制", "蔓延", "闷烧",
            "आग", "धुआँ", "जलना", "अलार्म", "निकासी", "मदद", "आपातकाल", "लपटें",
            "गर्मी", "खतरा", "इमारत", "राहत", "फँसा", "कॉल करना", "१०१", "फायरब्रिगेड",
            "पाइप", "हाइड्रेंट", "विस्फोट", "चिंगारी", "जंगल की आग", "रसोई", "बिजली",
            "शॉर्ट सर्किट", "गैस", "लीक", "छत", "ढहना", "सायरन", "पानी", "बुझाना",
            "जलन", "घायल", "निकासी", "सीढ़ियाँ", "निकास", "सुरक्षित", "पड़ोसी", "स्मोक अलार्म",
            "ज्वाला", "राहतकर्मी", "नियंत्रित", "अलार्म घंटी", "अति आवश्यक", "राहत दल", "दमकलकर्मी",
            "नियंत्रित करना", "फैलना", "धीमे-धीमे जलना",
            "حريق", "دخان", "احتراق", "إنذار", "إخلاء", "مساعدة", "طوارئ", "لهب",
            "حرارة", "خطر", "مبنى", "إنقاذ", "محاصر", "اتصال", "١١٩", "شاحنة إطفاء",
            "خرطوم", "صنبور إطفاء", "انفجار", "شرر", "حريق غابات", "مطبخ", "كهربائي",
            "ماس كهربائي", "غاز", "تسرب", "سطح", "انهيار", "صفارات إنذار", "ماء", "إطفاء",
            "حروق", "مصاب", "إخلاء", "درج", "مخرج", "آمن", "جار", "كاشف دخان",
            "مشعل", "مسعف", "مُسيطر عليه", "جرس إنذار", "عاجل", "فريق إنقاذ", "رجل إطفاء",
            "احتواء", "انتشار", "دخان هادئ"
        ]
    }
    
    static let hospitalSet: Set<String> = Set(Self.hospitalKeywords.map({ $0.lowercased() }))
    static let policeSet: Set<String> = Set(Self.policeKeywords.map({ $0.lowercased() }))
    static let fireSet: Set<String> = Set(Self.fireKeywords.map({ $0.lowercased() }))
    
    public func getDestinationPlace() -> DestinationPlaces? {
        var hospitalCount = 0, policeCount = 0, fireCount = 0
        
        let tokens = self.lowercased().components(separatedBy: CharacterSet.alphanumerics.inverted).filter({ !$0.isEmpty })
        for token in tokens {
            if Self.hospitalSet.contains(token) {
                hospitalCount += 1
            }
            
            if Self.policeSet.contains(token) {
                policeCount += 1
            }
            
            if Self.fireSet.contains(token) {
                fireCount += 1
            }
        }
        
        let result: [(DestinationPlaces, Int)] = [(.hospital, hospitalCount), (.police, policeCount), (.fireStation, fireCount)]
        let nonZeroResult = result.filter({ $0.1 > 0 })
        guard !nonZeroResult.isEmpty else {
            return nil
        }
        
        return nonZeroResult.sorted {
            if $0.1 != $1.1 {
                return $0.1 > $1.1
            }
            
            let order: [DestinationPlaces] = [.hospital, .police, .fireStation]
            return order.firstIndex(of: $0.0)! < order.firstIndex(of: $1.0)!
        }.first?.0
    }
}
