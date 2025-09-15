import 'ticket_store.dart';
import 'ticket_store_io.dart' if (dart.library.html) 'ticket_store_web.dart';

TicketStore getStore() => getImplStore();

