import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';

class SupabaseService {

  static final SupabaseClient client = Supabase.instance.client;

  static Future<List<AppNotification>> fetchNotifications() async {

    final data = await client
        .from('notifications')
        .select()
        .order('created_at', ascending: false);

    return (data as List).map((e) {

      return AppNotification(
        id: e['id'],
        title: e['title'],
        body: e['body'],
        time: DateTime.parse(e['created_at']).toLocal(),
      );

    }).toList();
  }

}