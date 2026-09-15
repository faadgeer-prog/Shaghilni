import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(ShaghilniApp(prefs: prefs));
}

class ShaghilniApp extends StatelessWidget {
  final SharedPreferences prefs;
  const ShaghilniApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'شغّلني',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans',
        scaffoldBackgroundColor: const Color(0xFFF7FAFA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087F78),
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF19B6AE), width: 1.5),
          ),
        ),
      ),
      home: AuthGate(prefs: prefs),
    );
  }
}

class AuthGate extends StatefulWidget {
  final SharedPreferences prefs;
  const AuthGate({super.key, required this.prefs});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    final logged = widget.prefs.getBool('loggedIn') ?? false;
    return logged
        ? MainShell(prefs: widget.prefs)
        : LoginPage(prefs: widget.prefs);
  }
}

class LoginPage extends StatefulWidget {
  final SharedPreferences prefs;
  const LoginPage({super.key, required this.prefs});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;

  void login() {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ادخل البريد وكلمة المرور')),
      );
      return;
    }
    widget.prefs.setBool('loggedIn', true);
    widget.prefs.setString('email', email.text.trim());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainShell(prefs: widget.prefs)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: const Color(0xFF9BEAE5),
                    child: Icon(Icons.work_rounded,
                        size: 45,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 18),
                  const Text('شغّلني',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  const Text('سجّل دخولك وابدأ تكسب من مهاراتك'),
                  const SizedBox(height: 35),
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: password,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => obscure = !obscure),
                        icon: Icon(obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: login,
                      child: const Text('تسجيل الدخول',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                  TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                        title: Text('نسيت كلمة المرور؟'),
                        content: Text(
                            'في نسخة الإنتاج اربط هذه الشاشة بخدمة استعادة كلمة المرور عبر البريد أو رقم الهاتف.'),
                      ),
                    ),
                    child: const Text('نسيت كلمة المرور؟'),
                  ),
                  const Divider(height: 35),
                  OutlinedButton.icon(
                    onPressed: () {
                      email.text = '';
                      password.text = '';
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('اكتب بياناتك ثم اضغط تسجيل الدخول لإنشاء حسابك التجريبي')),
                      );
                    },
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('إنشاء حساب جديد'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Task {
  String title, description, location;
  int price;
  double distance;
  Task(this.title, this.description, this.location, this.price, this.distance);
}

class MainShell extends StatefulWidget {
  final SharedPreferences prefs;
  const MainShell({super.key, required this.prefs});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  final tasks = <Task>[
    Task('تصوير محل من الخارج', 'تصوير 5 صور واضحة للواجهة وإرسالها داخل التطبيق.',
        'بحري', 5000, 1.2),
    Task('توصيل مستندات', 'استلام المستندات وتسليمها للعميل.',
        'الخرطوم', 7000, 2.4),
    Task('إدخال بيانات', 'إدخال بيانات في ملف منظم.', 'عن بُعد', 10000, 0),
    Task('شراء غرض من السوق', 'شراء غرض وتسليمه للعميل.', 'أم درمان', 6000, 3.1),
  ];

  int get balance => widget.prefs.getInt('balance') ?? 0;

  void changeBalance(int amount) {
    widget.prefs.setInt('balance', balance + amount);
    setState(() {});
  }

  void logout() {
    widget.prefs.setBool('loggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage(prefs: widget.prefs)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTab(prefs: widget.prefs, balance: balance, tasks: tasks,
          onBalance: changeBalance, onTaskAccepted: () => setState(() {})),
      TasksTab(tasks: tasks),
      WalletTab(prefs: widget.prefs, balance: balance, onBalance: changeBalance),
      AccountTab(prefs: widget.prefs, onLogout: logout),
    ];
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.work_outline), selectedIcon: Icon(Icons.work), label: 'المهام'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'المحفظة'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final SharedPreferences prefs;
  final int balance;
  final List<Task> tasks;
  final void Function(int) onBalance;
  final VoidCallback onTaskAccepted;
  const HomeTab({super.key, required this.prefs, required this.balance,
      required this.tasks, required this.onBalance, required this.onTaskAccepted});

  @override
  Widget build(BuildContext context) {
    final name = prefs.getString('name') ?? 'صديقي';
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFB8EFEB),
                child: Icon(Icons.notifications_none),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('صباح الخير 👋',
                      style: TextStyle(color: Colors.grey.shade700)),
                  Text(name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => WalletTab(prefs: prefs, balance: balance,
                      onBalance: onBalance)),
            ),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF087F78), Color(0xFF8DE7E1)],
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined,
                      color: Colors.white, size: 34),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('رصيدك الحالي',
                          style: TextStyle(color: Colors.white70)),
                      Text('$balance جنيه',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text('مهام مناسبة ليك',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...tasks.take(4).map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TaskCard(task: t, onAccepted: onTaskAccepted),
              )),
          const SizedBox(height: 10),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PublishTaskPage(onPublished: () {}),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('انشر مهمة',
                  style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onAccepted;
  const TaskCard({super.key, required this.task, required this.onAccepted});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text('${task.price} ج',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                const Spacer(),
                Expanded(
                  child: Text(task.title,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(task.description,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(task.title),
                        content: Text('${task.description}\n\nالموقع: ${task.location}\nالمكافأة: ${task.price} جنيه'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('إلغاء')),
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onAccepted();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم قبول المهمة')),
                              );
                            },
                            child: const Text('أقبل المهمة'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('أقبل المهمة'),
                ),
                const Spacer(),
                Text('${task.distance} كم',
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(width: 5),
                const Icon(Icons.location_on_outlined, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TasksTab extends StatefulWidget {
  final List<Task> tasks;
  const TasksTab({super.key, required this.tasks});
  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  final accepted = <String>{};

  @override
  Widget build(BuildContext context) {
    final mine = widget.tasks.where((t) => accepted.contains(t.title)).toList();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('مهامي',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          if (mine.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: const [
                    Icon(Icons.assignment_outlined, size: 55),
                    SizedBox(height: 12),
                    Text('ما عندك مهام مقبولة حالياً',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    SizedBox(height: 5),
                    Text('اقبل مهمة من الرئيسية وحتظهر هنا'),
                  ],
                ),
              ),
            )
          else
            ...mine.map((t) => Card(
                  child: ListTile(
                    title: Text(t.title, textAlign: TextAlign.right),
                    subtitle: const Text('قيد التنفيذ', textAlign: TextAlign.right),
                    trailing: const Icon(Icons.pending_actions),
                  ),
                )),
        ],
      ),
    );
  }
}

class WalletTab extends StatefulWidget {
  final SharedPreferences prefs;
  final int balance;
  final void Function(int) onBalance;
  const WalletTab({super.key, required this.prefs, required this.balance, required this.onBalance});
  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  void addMoney() {
    final amount = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('إضافة رصيد',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 15),
            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'المبلغ بالجنيه السوداني'),
            ),
            const SizedBox(height: 14),
            const Align(
              alignment: Alignment.centerRight,
              child: Text('طريقة الدفع',
                  style: TextStyle(fontWeight: FontWeight.w800)),
            ),
            RadioListTile(
              value: 'bank',
              groupValue: 'bank',
              onChanged: (_) {},
              title: const Text('تحويل بنكي / محفظة إلكترونية'),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final n = int.tryParse(amount.text) ?? 0;
                  if (n <= 0) return;
                  widget.onBalance(n);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('تمت إضافة الرصيد في النسخة التجريبية')),
                  );
                },
                child: const Text('تأكيد إضافة الرصيد'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.prefs.getInt('balance') ?? widget.balance;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('المحفظة',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  const Icon(Icons.account_balance_wallet, size: 50),
                  const SizedBox(height: 10),
                  Text('$b جنيه',
                      style: const TextStyle(
                          fontSize: 34, fontWeight: FontWeight.w900)),
                  const Text('الرصيد المتاح'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 55,
            child: FilledButton.icon(
              onPressed: addMoney,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('إضافة رصيد',
                  style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('سجل العمليات',
                  textAlign: TextAlign.right),
              subtitle: const Text('سيظهر هنا سجل الشحن والمكافآت',
                  textAlign: TextAlign.right),
              trailing: const Icon(Icons.chevron_left),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'ملاحظة: إضافة الرصيد هنا تجريبية فقط. في النسخة الحقيقية يجب ربطها ببوابة دفع أو محفظة إلكترونية والتحقق من العملية من الخادم.',
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class AccountTab extends StatefulWidget {
  final SharedPreferences prefs;
  final VoidCallback onLogout;
  const AccountTab({super.key, required this.prefs, required this.onLogout});
  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  Future<void> open(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.prefs.getString('name') ?? 'مستخدم جديد';
    final email = widget.prefs.getString('email') ?? '';
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.dark_mode_outlined),
              ),
              const Spacer(),
              const Text('حسابي',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 25),
          CircleAvatar(
            radius: 65,
            backgroundColor: const Color(0xFF9BEAE5),
            child: const Icon(Icons.person, size: 70),
          ),
          const SizedBox(height: 15),
          Text(name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          Text(email,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 25),
          Card(
            child: Column(
              children: [
                _AccountTile(
                  icon: Icons.badge_outlined,
                  title: 'المعلومات الشخصية',
                  onTap: () => open(ProfilePage(prefs: widget.prefs)),
                ),
                _AccountTile(
                  icon: Icons.auto_awesome_outlined,
                  title: 'مهاراتي',
                  onTap: () => open(SkillsPage(prefs: widget.prefs)),
                ),
                _AccountTile(
                  icon: Icons.security_outlined,
                  title: 'الأمان والخصوصية',
                  onTap: () => open(SecurityPage(prefs: widget.prefs)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _AccountTile({required this.icon, required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.chevron_left),
      trailing: Icon(icon),
      title: Text(title, textAlign: TextAlign.right),
      onTap: onTap,
    );
  }
}

class ProfilePage extends StatefulWidget {
  final SharedPreferences prefs;
  const ProfilePage({super.key, required this.prefs});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController name;
  late final TextEditingController phone;
  late final TextEditingController email;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.prefs.getString('name') ?? '');
    phone = TextEditingController(text: widget.prefs.getString('phone') ?? '');
    email = TextEditingController(text: widget.prefs.getString('email') ?? '');
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    email.dispose();
    super.dispose();
  }

  void save() {
    widget.prefs.setString('name', name.text.trim());
    widget.prefs.setString('phone', phone.text.trim());
    widget.prefs.setString('email', email.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ المعلومات الشخصية')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المعلومات الشخصية')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم الكامل')),
          const SizedBox(height: 14),
          TextField(controller: phone, keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'رقم الهاتف')),
          const SizedBox(height: 14),
          TextField(controller: email, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'البريد الإلكتروني')),
          const SizedBox(height: 22),
          SizedBox(height: 52, child: FilledButton(onPressed: save, child: const Text('حفظ التعديلات'))),
        ],
      ),
    );
  }
}

class SkillsPage extends StatefulWidget {
  final SharedPreferences prefs;
  const SkillsPage({super.key, required this.prefs});
  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  late List<String> skills;

  @override
  void initState() {
    super.initState();
    skills = widget.prefs.getStringList('skills') ?? [];
  }

  void save() => widget.prefs.setStringList('skills', skills);

  void addSkill() {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إضافة مهارة'),
        content: TextField(controller: c, decoration: const InputDecoration(labelText: 'اسم المهارة')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () {
              if (c.text.trim().isNotEmpty) {
                setState(() => skills.add(c.text.trim()));
                save();
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مهاراتي'),
        actions: [IconButton(onPressed: addSkill, icon: const Icon(Icons.add))],
      ),
      body: skills.isEmpty
          ? Center(
              child: FilledButton.icon(
                onPressed: addSkill,
                icon: const Icon(Icons.add),
                label: const Text('أضف أول مهارة'),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: skills.length,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  title: Text(skills[i], textAlign: TextAlign.right),
                  leading: IconButton(
                    onPressed: () {
                      setState(() => skills.removeAt(i));
                      save();
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                  trailing: const Icon(Icons.auto_awesome),
                ),
              ),
            ),
    );
  }
}

class SecurityPage extends StatelessWidget {
  final SharedPreferences prefs;
  const SecurityPage({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأمان والخصوصية')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('تغيير كلمة المرور', textAlign: TextAlign.right),
                  onTap: () => _passwordDialog(context),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.verified_user_outlined),
                  title: Text('التحقق من الحساب', textAlign: TextAlign.right),
                  subtitle: Text('فعّل التحقق عند ربط الخادم الحقيقي', textAlign: TextAlign.right),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('سياسة الخصوصية', textAlign: TextAlign.right),
                  onTap: () => _info(context, 'سياسة الخصوصية',
                      'هذه نسخة MVP. عند الإطلاق يجب إضافة سياسة خصوصية حقيقية توضح جمع البيانات واستخدامها وحذفها.'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('شروط الاستخدام', textAlign: TextAlign.right),
                  onTap: () => _info(context, 'شروط الاستخدام',
                      'يجب إضافة الشروط القانونية الخاصة بالمنصة قبل الإطلاق.'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _info(context, 'حذف الحساب',
                'في النسخة الحقيقية يجب تنفيذ حذف الحساب من الخادم بعد تأكيد المستخدم.'),
            icon: const Icon(Icons.delete_outline),
            label: const Text('حذف الحساب'),
          ),
        ],
      ),
    );
  }

  void _passwordDialog(BuildContext context) {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تغيير كلمة المرور'),
        content: TextField(
          controller: c,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'كلمة المرور الجديدة'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث كلمة المرور في النسخة التجريبية')),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _info(BuildContext context, String title, String text) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(text, textAlign: TextAlign.right),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
        ],
      ),
    );
  }
}

class PublishTaskPage extends StatefulWidget {
  final VoidCallback onPublished;
  const PublishTaskPage({super.key, required this.onPublished});
  @override
  State<PublishTaskPage> createState() => _PublishTaskPageState();
}

class _PublishTaskPageState extends State<PublishTaskPage> {
  final title = TextEditingController();
  final details = TextEditingController();
  final price = TextEditingController();
  final location = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    details.dispose();
    price.dispose();
    location.dispose();
    super.dispose();
  }

  void publish() {
    if (title.text.trim().isEmpty ||
        details.text.trim().isEmpty ||
        price.text.trim().isEmpty ||
        location.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اكمل بيانات المهمة أولاً')),
      );
      return;
    }
    widget.onPublished();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نشر المهمة في النسخة التجريبية')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نشر مهمة')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('شنو محتاج؟',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          TextField(controller: title, decoration: const InputDecoration(labelText: 'عنوان المهمة')),
          const SizedBox(height: 14),
          TextField(controller: details, maxLines: 4,
              decoration: const InputDecoration(labelText: 'التفاصيل')),
          const SizedBox(height: 14),
          TextField(controller: price, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'المبلغ (جنيه سوداني)')),
          const SizedBox(height: 14),
          TextField(controller: location,
              decoration: const InputDecoration(labelText: 'الموقع')),
          const SizedBox(height: 24),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: publish,
              icon: const Icon(Icons.publish),
              label: const Text('نشر المهمة',
                  style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}
