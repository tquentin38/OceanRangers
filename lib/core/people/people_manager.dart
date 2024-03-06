import 'dart:math';

import 'package:ocean_rangers/boat/boat_dialog.dart';
import 'package:ocean_rangers/core/game_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeopleManager {
  List<People> peoples = [];
  PeopleManager() {
    for (PeopleDialog rt in PeopleDialog.values) {
      peoples.add(People(rt, 0, this));
    }
    loadSave();
  }

  Future<void> loadSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (People peo in peoples) {
      int? savedValue = prefs.getInt("people_${peo.type.identifier}");
      if (savedValue != null) {
        peo.setHeartPoint(savedValue);
      }
    }
  }

  Future<void> saveData(People res) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("people_${res.type.identifier}", res.heartPoint);
  }

  Future<void> saveDatas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (People peo in peoples) {
      await prefs.setInt("people_${peo.type.identifier}", peo.heartPoint);
    }
  }

  DialogHolder getDialog(PeopleDialog peopleDialog) {
    for (People peo in peoples) {
      if (peo.type == peopleDialog) {
        return DialogHolder(
            dialogs: peo.getDialog(), hearts: peo.heartPoint, people: peo);
      }
    }
    return DialogHolder(dialogs: [], hearts: 0, people: null);
  }
}

class People {
  PeopleDialog type;
  int heartPoint = 0;
  int lastLevel = 0;
  PeopleManager manager;

  People(this.type, this.heartPoint, this.manager);

  String getName() {
    return type.name;
  }

  void setHeartPoint(int newPoint) {
    heartPoint = newPoint;
    for (double levelPoint in type.valueForLevel) {
      if (heartPoint >= levelPoint) {
        lastLevel++;
      }
    }
  }

  List<String> getDialog() {
    List<String> dialog = [];
    List<List<String>> list = [];
    for (int v in type.dialogForLevel.keys) {
      if (heartPoint == 0) {
        if (v == 0) {
          dialog = type.dialogForLevel[v]!.first;
        }
      } else {
        /*if (v == 1) {
           = type.dialogForLevel[v]!;
         
        }*/
        if (v > 1) {
          if (heartPoint >= type.valueForLevel[v - 1]) {
            for (List<String> ls in type.dialogForLevel[v]!) {
              list.add(ls);
            }
          }
        } else {
          if (v != 0) {
            for (List<String> ls in type.dialogForLevel[v]!) {
              list.add(ls);
            }
          }
        }
      }
    }
    if (heartPoint != 0) {
      dialog = list[Random().nextInt(list.length - 1)];
    }

    if (GameFile().pseudo != null) {
      List<String> dialogModif = [];
      for (String s in dialog) {
        dialogModif.add(s.replaceAll("::player::", GameFile().pseudo!));
      }
      dialog = dialogModif;
    }
    if (dialog.isNotEmpty) {
      heartPoint++;
      if (heartPoint >= type.valueForLevel[lastLevel]) {
        dialog = [type.dialogLevelUp[lastLevel]];
        lastLevel++;
      }
      manager.saveData(this);
    }
    return dialog;
  }
}

enum PeopleDialog implements Comparable<PeopleDialog> {
  commandante(identifier: 0, name: "Commander", levelMax: 5, valueForLevel: [
    5,
    10,
    20,
    25,
    500
  ], dialogForLevel: {
    0: [
      [
        "Welcome aboard, recruit! I'm the one steering this vessel through the deep blues. My dad, a humble fisherman, instilled in me the love for the sea. Over the years, I've honed my skills, and now, it's my turn to protect what I cherish most – the ocean and its rich biodiversity. It's high time we stand against the relentless dumping of waste into these waters."
      ]
    ],
    1: [
      [
        "Sometimes, I stare into the horizon and see the endless battles ahead. But then, I watch a dolphin leap or a flock of birds skim the waves, and it reignites my hope. We're not just fighting for us, but for every creature calling the ocean home."
      ],
      [
        "It's easy to feel disheartened by the scale of pollution, but sitting idle isn't an option. We track down those responsible, we educate, and we clean up, one piece at a time. The ocean is resilient, and so are we. Ready to dive in?"
      ],
      [
        "I know the battle seems daunting, but remember, every small action counts. My father used to say, 'The ocean doesn't need saviors, just regular folks willing to lend a hand.' Let's prove him right. Together, we can make a difference."
      ],
      [
        "Look at this mess! Reminds me of the time I stumbled upon a beach smeared in oil. That day, I vowed to chase down the culprits polluting our seas. It's not just about cleaning up; it's about preserving our marine sanctuary. Are you with me?"
      ],
      [
        "This isn't a mission one can tackle alone. It takes a crew, a community, united for a cause. Your presence here is a beacon of hope, a reminder that change is possible when we band together. Let's steer this ship towards a brighter future, shall we?"
      ]
    ],
    2: [
      [
        "You know, ::player::, your enthusiasm is contagious. It's good to have someone on board who's not just here for the job but genuinely cares about the cause. Your dedication is what sets you apart."
      ],
      [
        "I've been observing your commitment to understanding the ins and outs of our operations. It's clear you're not just here to sail the seas but to make a difference. Admirable, truly admirable."
      ],
      [
        "I've seen the spark in your eyes, ::player::. It tells me you're not just a crew member; you're someone who believes in the importance of our mission. Keep that passion alive, and we'll achieve great things together."
      ],
      [
        "Your proactive approach hasn't gone unnoticed. It's refreshing to work with someone who takes the initiative. Let's continue building on this momentum, making waves in both the literal and figurative sense."
      ],
      [
        "We're a team, ::player::, and your efforts are strengthening our unity. It's not just about following orders; it's about investing in the shared vision we have for a healthier ocean. Looking forward to achieving more milestones together."
      ]
    ]
  }, dialogLevelUp: [
    "I'm starting to see the passion in your eyes. It reminds me of my early days.",
    "You're proving to be quite the asset to our team. Keep up the good work.",
    "I trust you more with each passing day. Together, we can make a real difference.",
    "Your dedication to our cause warms my heart. I'm proud to have you on board.",
    "You're not just a crew member; you're a vital part of this family. We stand united for the ocean."
  ]),
  second(identifier: 1, name: "Second", levelMax: 5, valueForLevel: [
    5,
    10,
    20,
    25,
    500
  ], dialogForLevel: {
    0: [
      [
        "Hi there! I'm Rebecca Anderson, the captain's right hand and your go-to marine biologist on the Poseidon. For the past five years, I've been navigating these waters, uncovering the ocean's mysteries. I'm here to guide you through the wonders and challenges of marine life. Ready to dive deep into the unknown?"
      ]
    ],
    1: [
      [
        "Did you know that the lanternfish is one of the most common, yet unseen, species in the ocean? These creatures can illuminate the darkest depths of the sea. Just like them, there's so much hidden potential in these waters, waiting for us to discover."
      ],
      [
        "Our next mission is unlike any other. We're venturing into uncharted territories, where few have dared to go. The species we'll encounter are as mysterious as the ocean itself. Keep your eyes peeled and your mind open. Every discovery tells a story."
      ],
      [
        "The ocean tests us in ways we can't always predict, but remember, every challenge is an opportunity for growth. As we navigate these treacherous waters, let's rely on each other's strengths. Together, there's no storm we can't weather."
      ],
      [
        "Every species we encounter plays a crucial role in the ocean's ecosystem. It's our responsibility to ensure their home remains safe and healthy. Conservation isn't just about protecting; it's about respecting and coexisting with these magnificent creatures."
      ],
      [
        "Today's discovery adds a new piece to the puzzle of the ocean's vast ecosystem. It's a reminder of how little we know and how much more there is to explore. Let's keep pushing the boundaries of our knowledge and care for these waters as if they were our own."
      ],
      [
        "I've seen the passion in each of your eyes, the same passion that drives me to uncover the ocean's secrets. Let's channel that energy into our mission, making every exploration count. The ocean is our greatest teacher, and we are its students."
      ],
    ],
    2: [
      [
        "I've been impressed by your curiosity, ::player::. You're not just navigating the ocean; you're diving deep into understanding its intricacies. Your eagerness to learn is a valuable asset to our marine exploration team."
      ],
      [
        "Your interest in marine biology is evident, and it's inspiring. You're not just here for the adventure; you're actively engaging with the scientific aspects of our journey. It's a pleasure working with someone who values the knowledge we gain."
      ],
      [
        "I've noticed your dedication to our mission of exploring the ocean's mysteries. It's more than a job for you; it's a quest for understanding. Your contributions are shaping us into a formidable force for marine conservation."
      ],
      [
        "Your commitment to marine life is evident in your actions, ::player::. You're not just a passenger on this ship; you're an active participant in unraveling the wonders of the sea. Let's keep diving deeper into the unknown together."
      ],
      [
        "Your involvement in our scientific pursuits is admirable. I can see you're not just content with surface-level exploration; you want to delve into the details. Exciting times lie ahead as we uncover the secrets hidden beneath the waves."
      ]
    ]
  }, dialogLevelUp: [
    "Your curiosity about marine life is truly refreshing. Let's discover the ocean's secrets together.",
    "I appreciate your efforts in learning more about marine biology. You're doing great!",
    "Your enthusiasm for marine conservation is contagious. I feel inspired by your dedication.",
    "I consider you a peer in our scientific endeavors. Your insights are invaluable.",
    "We've formed a bond that goes beyond just colleagues. I'm grateful for your friendship and support."
  ]),
  techguy(identifier: 2, name: "TechGuy", levelMax: 5, valueForLevel: [
    5,
    10,
    20,
    25,
    500
  ], dialogForLevel: {
    0: [
      [
        "Hey there! I'm Sam Brown, the Poseidon's go-to guy for all things tech. Been tinkering with electronics and keeping this beauty of a submarine in top shape for a decade now. You need something fixed or upgraded, I'm your man. And yes, that includes our little robotic friend who'll be joining us on our deep-sea adventures."
      ]
    ],
    1: [
      [
        "You see, in this world of fast tech, it's easy to forget the impact we have on our planet. That's why I'm big on reusing and repurposing old gear. Why buy new when you can give a second life to what's already out there? It's not just about saving money; it's about saving our ocean."
      ],
      [
        "Ah, this old circuit board? Most would toss it, but with a bit of creativity, it's ready for a second act. It's like solving a puzzle with the planet's well-being in mind. Every piece we save from the landfill is a small victory for us and the ocean."
      ],
      [
        "In this era of streaming everything, we often forget the value of downloading and keeping. It's not just about having something to watch or listen to offline; it's about reducing our digital footprint. More downloads, less streaming means we demand less from our servers and, by extension, from our environment."
      ],
      [
        "Planned obsolescence? Don't get me started. It's a cycle that's tough to break, but not impossible. That's why I'm here, doing my part to ensure our tech lasts as long as possible. If we're going to fight this, it starts with resisting the urge to upgrade to the latest and greatest unnecessarily."
      ],
      [
        "If there's one thing I've learned, it's that necessity truly is the mother of invention. With a bit of ingenuity, what's old can be new again. And in doing so, we're not just solving problems; we're setting an example. Let's innovate in harmony with our planet."
      ],
      [
        "Being part of this crew, working on the Poseidon, it's more than a job; it's a calling. Every repair, every upgrade, it's a step towards a more sustainable future. We're not just exploring the ocean; we're showing how technology can work for us without working against the earth."
      ],
    ],
    2: [
      [
        "Hey, ::player::, your interest in the tech side of things hasn't gone unnoticed. You're not just a passenger; you're becoming a key player in keeping our electronics humming. I appreciate the effort."
      ],
      [
        "Your knack for technology is starting to shine through. I've seen you tinkering around, and it's clear you're more than just a user. Keep exploring the tech world; there's a lot we can achieve together."
      ],
      [
        "I've observed your growing familiarity with our tech setup. It's evident you're not afraid to get your hands dirty in the electronic realm. Your proactive approach to tech matters is making a positive impact."
      ],
      [
        "Your tech-savvy mindset is a valuable asset to the team. It's not just about using gadgets; you're actively involved in understanding and improving our tech infrastructure. Let's keep innovating together."
      ],
      [
        "Your involvement in the tech side of our operations is becoming increasingly valuable. It's clear you're not just here for the ride; you want to contribute to our technological journey. Looking forward to more collaborative breakthroughs."
      ]
    ]
  }, dialogLevelUp: [
    "You're showing a real knack for technology. There's much we can achieve with your skills.",
    "Your assistance in the tech lab has not gone unnoticed. I'm impressed by your progress.",
    "We're starting to make a great team. Your tech-savvy approach is making a difference.",
    "Your dedication to sustainable tech solutions is admirable. I'm learning a lot from you.",
    "You've become indispensable to our mission and to me personally. Thanks for being here."
  ]),
  ouvrier(identifier: 3, name: "Ouvrier", levelMax: 5, valueForLevel: [
    5,
    10,
    20,
    25,
    500
  ], dialogForLevel: {
    0: [
      [
        "Hey! I'm Dean, the go-to guy for making old things work like new again on this giant tin can we call Poseidon. Got a knack for turning what most folks would call 'junk' into treasure."
      ]
    ],
    1: [
      [
        "Here's the thing - why toss something out when a bit of elbow grease can make it as good as new? It's not just thriftiness; it's like giving a big ol' bear hug to Mother Earth."
      ],
      [
        "I'm all for recycling, but let's not kid ourselves - sometimes you gotta bring in the new stuff to keep us afloat. But hey, every piece of metal has its story, right?"
      ],
      [
        "Keepin' things running smooth isn't just good for the ship; it's our little high-five to the environment. Less waste, less worry, and a whole lot more adventure."
      ],
      [
        "Every gadget I fix is one less gadget in the landfill, and that's a win in my book. Manufacturing's a beast on nature, so let's fix more and make less. Deal?"
      ],
      [
        "It's not rocket science—fix more, waste less. If I can get an old engine purring like a kitten, think about what else we can do. It's all about the small wins, my friend."
      ],
      [
        "Life on Poseidon? It's more than just a job; it's a chance to show the world how to treat our planet better. We're not just sailing; we're steering towards a greener tomorrow."
      ],
    ],
    2: [
      [
        "You're catching on fast, ::player::. Your knack for repairs is showing. It's not just about fixing things; it's about understanding the heart of the machinery. Keep up the good work."
      ],
      [
        "I've seen you getting your hands dirty in the workshop. Your interest in repairs is clear, and it's making my job a whole lot easier. We're turning into quite the dynamic duo."
      ],
      [
        "Your mechanical skills are shaping up nicely. It's more than just fixing broken parts; it's about understanding the rhythm of the machine. I appreciate your dedication to our ship's well-being."
      ],
      [
        "I've noticed your commitment to sustainable repairs. You're not just patching things up; you're giving our equipment a new lease on life. Your approach aligns perfectly with our mission."
      ],
      [
        "You've become a real asset in the workshop, ::player::. It's not just about maintenance; it's about understanding the soul of the machinery. Looking forward to more collaboration in keeping our ship in top shape."
      ]
    ]
  }, dialogLevelUp: [
    "I see you're getting the hang of things around here. Your help is making my job easier.",
    "You've got a good eye for repair and reuse. That's the spirit we need on this ship.",
    "Your commitment to sustainability is making waves. I'm glad to have you on the team.",
    "We're not just fixing machines; we're fixing the future. Thanks for your hard work.",
    "You're more than a crew member to me now. You're a pillar of this ship's heart and soul."
  ]),
  voyager(identifier: 4, name: "Voyage", levelMax: 5, valueForLevel: [
    5,
    10,
    20,
    25,
    500
  ], dialogForLevel: {
    0: [
      [
        "Hello, lovely to meet you! I'm Stacy, your go-to for both beauty and guarding our beautiful planet. It's amazing how taking care of our environment adds to our glow, don't you think?"
      ]
    ],
    1: [
      [
        "Did you know that something as simple as sorting our waste can make a world of difference? It's all about those small, mindful steps that lead to a big impact. Together, we can make our beaches and oceans as pristine as they ought to be."
      ],
      [
        "Reducing plastic use isn't just good practice; it's a statement of love for our oceans and marine life. Every bottle we refuse, every bag we reuse... it's a step toward healing our planet."
      ],
      [
        "I believe in the power of knowledge. By understanding the effects of our choices, from the cosmetics we use to the way we travel, we're empowered to make decisions that protect our home. It's about beauty, inside and out."
      ],
      [
        "Travel opens our eyes to the world's beauty, but it also bears a footprint. It's about finding that balance, embracing sustainable ways to explore without harming what we love. Let's be adventurers who care."
      ],
      [
        "Change begins with us, with every small act of kindness toward the earth. Whether you're a local or just passing through, your actions count. Let's be the change, one step at a time."
      ],
      [
        "My mission is more than skin-deep. It's about fostering a community that cherishes and protects our natural wonders. Together, we're not just enhancing our beauty; we're safeguarding the planet's."
      ],
    ],
    2: [
      [
        "Your interest in environmental protection is shining through, ::player::. It's more than just a passing concern; you're actively engaged. Keep nurturing that passion; it's contagious."
      ],
      [
        "I've noticed your dedication to eco-friendly practices. Your commitment to making small changes is inspiring. We're creating ripples of change, and you're a vital part of that movement."
      ],
      [
        "Your actions are speaking louder than words when it comes to protecting our environment. It's clear you're not just a spectator; you're an advocate. Let's continue our journey towards a greener world together."
      ],
      [
        "I appreciate your efforts in spreading awareness about environmental issues. You're not just talking the talk; you're walking the walk. Your passion for the planet is a beacon for others to follow."
      ],
      [
        "You've become an integral part of our mission, ::player::. Your dedication to environmental causes is making waves among the crew. Let's keep fostering this commitment to a sustainable future."
      ]
    ]
  }, dialogLevelUp: [
    "Your interest in environmental protection is commendable. Let's keep learning together.",
    "Seeing your dedication to our cause is inspiring. You're making a real difference.",
    "Your actions speak louder than words. You're a true advocate for the environment.",
    "Your passion for this planet has touched my heart. Together, we can achieve wonders.",
    "Your commitment has truly moved me. I'm proud to stand with you in this fight."
  ]),
  /*next(identifier: 4, name: "Second", levelMax: 5, valueForLevel: [
    100,
    200,
    300,
    400,
    500
  ], dialogForLevel: {
    0: [[]],
    1: [
      [],
      [],
      [],
      [],
      [],
      [],
      [],
      [],
    ],
    2: [[]]
  }),*/
  ;

  const PeopleDialog(
      {required this.identifier,
      required this.name,
      required this.levelMax,
      required this.valueForLevel,
      required this.dialogForLevel,
      required this.dialogLevelUp});

  final int identifier;
  final String name;
  final int levelMax;
  final List<double> valueForLevel;
  final Map<int, List<List<String>>> dialogForLevel;
  final List<String> dialogLevelUp;

  @override
  int compareTo(PeopleDialog other) => identifier - other.identifier;
}
