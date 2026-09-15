import 'package:flutter/material.dart';

void main() {
  runApp(const ShaghilniApp());
}

class ShaghilniApp extends StatefulWidget {
  const ShaghilniApp({super.key});

  @override
  State<ShaghilniApp> createState() => _ShaghilniAppState();
}

class _ShaghilniAppState extends State<ShaghilniApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF0B7A75);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'شغّلني',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          filled: true,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          filled: true,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MainShell(onToggleTheme: _toggleTheme),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const MainShell({super.key, required this.onToggleTheme});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomePage(),
    TasksPage(),
    WalletPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_index]),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateTaskPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('انشر مهمة'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() => _index = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'المهام',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'المحفظة',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = demoTasks.take(3).toList();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'صباح الخير 👋',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'جاهز تكسب اليوم؟',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          sliver: SliverToBoxAdapter(
            child: _BalanceCard(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Text(
              'مهام مناسبة ليك',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.separated(
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => TaskCard(task: tasks[i]),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary,
            scheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor:
                scheme.onPrimary.withValues(alpha: .12),
            child: Icon(
              Icons.account_balance_wallet,
              color: scheme.onPrimary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رصيدك الحالي',
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '0 جنيه',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_back_ios_new,
            color: scheme.onPrimary,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title: Text('المهام'),
          automaticallyImplyLeading: false,
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          sliver: SliverList.separated(
            itemCount: demoTasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => TaskCard(
              task: demoTasks[i],
            ),
          ),
        ),
      ],
    );
  }
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title: Text('المحفظة'),
          automaticallyImplyLeading: false,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.wallet,
                          size: 42,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '0 جنيه',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 6),
                        const Text('الرصيد المتاح'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('سجل العمليات'),
                    subtitle: const Text(
                      'لا توجد عمليات حتى الآن',
                    ),
                    trailing: const Icon(
                      Icons.chevron_left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('حسابي'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                final state = context
                    .findAncestorStateOfType<_ShaghilniAppState>();

                state?._toggleTheme();
              },
              icon: const Icon(
                Icons.dark_mode_outlined,
              ),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            100,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 44,
                  child: Icon(
                    Icons.person,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'مستخدم جديد',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'أكمل بياناتك عشان تبدأ',
                ),
                const SizedBox(height: 20),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.badge_outlined,
                        ),
                        title: const Text(
                          'المعلومات الشخصية',
                        ),
                        trailing: const Icon(
                          Icons.chevron_left,
                        ),
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.auto_awesome_outlined,
                        ),
                        title: const Text('مهاراتي'),
                        trailing: const Icon(
                          Icons.chevron_left,
                        ),
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.security_outlined,
                        ),
                        title: const Text(
                          'الأمان والخصوصية',
                        ),
                        trailing: const Icon(
                          Icons.chevron_left,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TaskDetailsPage(
                task: task,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 23,
                    child: Icon(task.icon),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.location,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${task.price} ج',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _Tag(
                    icon: Icons.schedule,
                    text: task.time,
                  ),
                  const SizedBox(width: 8),
                  _Tag(
                    icon: Icons.near_me_outlined,
                    text: task.distance,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Tag({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }
}

class TaskDetailsPage extends StatelessWidget {
  final Task task;

  const TaskDetailsPage({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المهمة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(
                      task.icon,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    task.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(task.description),
                  const SizedBox(height: 18),
                  _InfoRow(
                    Icons.location_on_outlined,
                    task.location,
                  ),
                  _InfoRow(
                    Icons.schedule,
                    task.time,
                  ),
                  _InfoRow(
                    Icons.payments_outlined,
                    '${task.price} جنيه',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'تم إرسال طلب قبول المهمة بنجاح',
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.check_circle_outline,
            ),
            label: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 14,
              ),
              child: Text('أقبل المهمة'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow(
    this.icon,
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() =>
      _CreateTaskPageState();
}

class _CreateTaskPageState
    extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _location = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _price.dispose();
    _location.dispose();
    super.dispose();
  }

  void _publish() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نشر المهمة بنجاح'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نشر مهمة'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'شنو المهمة البتحتاج زول يعملها؟',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'عنوان المهمة',
                hintText: 'مثلاً: تصوير محل',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'اكتب عنوان المهمة';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'وصف المهمة',
                hintText:
                    'اكتب التفاصيل المطلوبة بوضوح',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'اكتب وصف المهمة';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _location,
              decoration: const InputDecoration(
                labelText: 'الموقع',
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'حدد الموقع';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'المبلغ بالجنيه',
                prefixIcon: Icon(
                  Icons.payments_outlined,
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'حدد المبلغ';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _publish,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 14,
                ),
                child: Text('نشر المهمة'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final String title;
  final String description;
  final String location;
  final String time;
  final String distance;
  final int price;
  final IconData icon;

  const Task({
    required this.title,
    required this.description,
    required this.location,
    required this.time,
    required this.distance,
    required this.price,
    required this.icon,
  });
}

const demoTasks = <Task>[
  Task(
    title: 'تصوير محل من الخارج',
    description:
        'محتاج شخص قريب يصور واجهة محل بعدة صور واضحة.',
    location: 'بحري',
    time: 'اليوم',
    distance: '1.2 كم',
    price: 5000,
    icon: Icons.camera_alt_outlined,
  ),
  Task(
    title: 'توصيل مستندات',
    description:
        'استلام ظرف وتسليمه في الموقع المحدد بأمان.',
    location: 'الخرطوم',
    time: 'خلال ساعتين',
    distance: '2.4 كم',
    price: 7000,
    icon: Icons.local_shipping_outlined,
  ),
  Task(
    title: 'إدخال بيانات',
    description:
        'إدخال مجموعة بيانات بسيطة في ملف Excel.',
    location: 'عن بُعد',
    time: 'مرن',
    distance: 'عن بُعد',
    price: 10000,
    icon: Icons.table_chart_outlined,
  ),
  Task(
    title: 'شراء غرض من السوق',
    description:
        'شراء غرض محدد وتسليمه في نقطة متفق عليها.',
    location: 'أم درمان',
    time: 'اليوم',
    distance: '3.1 كم',
    price: 6000,
    icon: Icons.shopping_bag_outlined,
  ),
];
