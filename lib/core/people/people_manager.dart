import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class PeopleManager {
  List<People> peoples = [];
  PeopleManager() {
    for (PeopleDialog rt in PeopleDialog.values) {
      peoples.add(People(rt, 0, this));
    }
  }

  Future<void> loadSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (People peo in peoples) {
      int? savedValue = prefs.getInt("people_${peo.type.identifier}");
      if (savedValue != null) {
        peo.heartPoint = savedValue;
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

  List<String> getDialog(PeopleDialog peopleDialog) {
    for (People peo in peoples) {
      if (peo.type == peopleDialog) {
        return peo.getDialog();
      }
    }
    return [];
  }
}

class People {
  PeopleDialog type;
  int heartPoint = 0;
  PeopleManager manager;

  People(this.type, this.heartPoint, this.manager);

  String getName() {
    return type.name;
  }

  List<String> getDialog() {
    List<String> dialog = [];
    for (int v in type.dialogForLevel.keys) {
      if (heartPoint == 0) {
        if (v == 0) {
          dialog = type.dialogForLevel[v]!.first;
        }
      } else {
        if (v == 1) {
          List<List<String>> list = type.dialogForLevel[v]!;
          dialog = list[Random().nextInt(list.length - 1)];
        }
      }
    }

    if (dialog.isNotEmpty) {
      heartPoint++;
      manager.saveData(this);
    }
    return dialog;
  }
}

enum PeopleDialog implements Comparable<PeopleDialog> {
  commandante(identifier: 0, name: "Commander", levelMax: 5, valueForLevel: [
    100,
    200,
    300,
    400,
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
    2: [[]]
  }),
  second(identifier: 1, name: "Second", levelMax: 5, valueForLevel: [
    100,
    200,
    300,
    400,
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
    2: [[]]
  }),
  techguy(identifier: 2, name: "TechGuy", levelMax: 5, valueForLevel: [
    100,
    200,
    300,
    400,
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
    2: [[]]
  }),
  ouvrier(identifier: 3, name: "Ouvrier", levelMax: 5, valueForLevel: [
    100,
    200,
    300,
    400,
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
    2: [[]]
  }),
  voyager(identifier: 4, name: "Voyage", levelMax: 5, valueForLevel: [
    100,
    200,
    300,
    400,
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
    2: [[]]
  }),
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
      required this.dialogForLevel});

  final int identifier;
  final String name;
  final int levelMax;
  final List<double> valueForLevel;
  final Map<int, List<List<String>>> dialogForLevel;

  @override
  int compareTo(PeopleDialog other) => identifier - other.identifier;
}
