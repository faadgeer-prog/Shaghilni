import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const ShaghilniApp());

class ShaghilniApp extends StatelessWidget {
  const ShaghilniApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF155EEF), brightness: Brightness.light);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'شغّلني',
      theme: ThemeData(
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        textTheme: GoogleFonts.cairoTextTheme(),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
        ),
        cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
      ),
      routerConfig: GoRouter(routes: [
        GoRoute(path: '/', builder: (_, __) => const HomePage()),
        GoRoute(path: '/publish', builder: (_, __) => const PublishTaskPage()),
      ]),
    );
  }
}

class Task {
  final String title, description, location;
  final int price;
  final double distance;
  const Task({required this.title, required this.description, required this.location, required this.price, required this.distance});
}

const tasks = <Task>[
  Task(title: 'تصوير واجهة محل', description: 'تصوير 5 صور واضحة للواجهة وإرسالها داخل التطبيق.', location: 'بحري', price: 5000, distance: 1.2),
  Task(title: 'شراء وتسليم طلب', description: 'شراء غرض من متجر قريب وتسليمه للعميل.', location: 'الخرطوم', price: 8000, distance: 2.4),
  Task(title: 'إدخال بيانات', description: 'إدخال بيانات فواتير في ملف منظم.', location: 'أم درمان', price: 12000, distance: 4.1),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('شغّلني', style: TextStyle(fontWeight: FontWeight.w800)), Text('فرص قريبة منك', style: TextStyle(fontSize: 12))]),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded))],
      ),
      body: IndexedStack(index: index, children: [
        _tasksView(context),
        const Center(child: Text('طلباتك ستظهر هنا')),
        const Center(child: Text('ملفك الشخصي')),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => context.push('/publish'), icon: const Icon(Icons.add_rounded), label: const Text('نشر مهمة')),
      bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v), destinations: const [
        NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'اكتشف'),
        NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'مهامي'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
      ]),
    );
  }

  Widget _tasksView(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 110), children: [
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(24)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('عندك وقت فاضي؟', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800)),
        SizedBox(height: 6), Text('حوّل وقتك ومهاراتك إلى دخل.', style: TextStyle(color: Colors.white70)),
      ]),
    ),
    const SizedBox(height: 22),
    const Text('مهام مناسبة ليك', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
    const SizedBox(height: 12),
    ...tasks.map((t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: TaskCard(task: t))),
  ]);
}

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Expanded(child: Text(task.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))), Text('${task.price} ج.س', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900))]),
    const SizedBox(height: 8), Text(task.description, style: const TextStyle(color: Colors.black54)),
    const SizedBox(height: 14), Row(children: [Icon(Icons.location_on_outlined, size: 18, color: Colors.grey.shade600), const SizedBox(width: 4), Text('${task.location} • ${task.distance} كم', style: const TextStyle(color: Colors.black54)), const Spacer(), FilledButton(onPressed: () {}, child: const Text('أقبل المهمة'))]),
  ])));
}

class PublishTaskPage extends StatelessWidget {
  const PublishTaskPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('نشر مهمة')), body: ListView(padding: const EdgeInsets.all(20), children: [
    const Text('شنو محتاج؟', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
    const SizedBox(height: 20),
    const TextField(decoration: InputDecoration(labelText: 'عنوان المهمة', hintText: 'مثلاً: تصوير واجهة محل')),
    const SizedBox(height: 14),
    const TextField(maxLines: 4, decoration: InputDecoration(labelText: 'التفاصيل', hintText: 'اكتب المطلوب بوضوح')),
    const SizedBox(height: 14),
    const TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'المبلغ (جنيه سوداني)')),
    const SizedBox(height: 14),
    const TextField(decoration: InputDecoration(labelText: 'الموقع', prefixIcon: Icon(Icons.location_on_outlined))),
    const SizedBox(height: 24),
    FilledButton.icon(onPressed: () => context.pop(), icon: const Icon(Icons.publish_rounded), label: const Padding(padding: EdgeInsets.all(4), child: Text('نشر المهمة'))),
  ]));
}
