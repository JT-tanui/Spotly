import 'package:flutter/material.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Inbox',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Notifications'),
            Tab(text: 'Messages'),
          ],
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsTab(),
          _buildMessagesTab(),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 120, bottom: 16),
      itemCount: 15,
      itemBuilder: (context, index) {
        return _buildNotificationItem(index);
      },
    );
  }

  Widget _buildMessagesTab() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 120, bottom: 16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildMessageItem(index);
      },
    );
  }

  Widget _buildNotificationItem(int index) {
    // Different notification types
    final notificationTypes = [
      {
        'icon': Icons.event_available,
        'color': Colors.green,
        'text': 'Your event is starting in 1 hour',
      },
      {
        'icon': Icons.person_add,
        'color': Colors.blue,
        'text': 'Alex started following you',
      },
      {
        'icon': Icons.favorite,
        'color': Colors.red,
        'text': 'Emma liked your event',
      },
      {
        'icon': Icons.comment,
        'color': Colors.orange,
        'text': 'New comment on your event',
      },
      {
        'icon': Icons.add_reaction,
        'color': Colors.purple,
        'text': 'David is interested in your event',
      },
    ];

    final notificationType =
        notificationTypes[index % notificationTypes.length];

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (notificationType['color'] as Color).withOpacity(0.2),
        child: Icon(
          notificationType['icon'] as IconData,
          color: notificationType['color'] as Color,
          size: 20,
        ),
      ),
      title: Text(notificationType['text'] as String),
      subtitle: Text('${index + 1} hour${index + 1 > 1 ? 's' : ''} ago'),
      trailing: index % 3 == 0
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            )
          : null,
      onTap: () {
        // Handle notification tap
      },
    );
  }

  Widget _buildMessageItem(int index) {
    final names = [
      'John Doe',
      'Jane Smith',
      'Robert Johnson',
      'Emily Davis',
      'Michael Brown',
      'Amanda Wilson',
      'David Lee',
      'Sarah Taylor',
    ];

    final messages = [
      'Hey, are you coming to the event?',
      'The place looks amazing!',
      'Can you share more details?',
      'I\'ll be there on time',
      'Thanks for the invitation',
      'Looking forward to seeing you',
      'Is there parking available?',
      'Can I bring a friend?',
    ];

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          'https://picsum.photos/seed/${index + 300}/200',
        ),
      ),
      title: Text(names[index % names.length]),
      subtitle: Text(
        messages[index % messages.length],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${index + 1}:${(index * 10) % 60 < 10 ? '0' : ''}${(index * 10) % 60} PM',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          if (index % 2 == 0)
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        // Handle message tap
      },
    );
  }
}
