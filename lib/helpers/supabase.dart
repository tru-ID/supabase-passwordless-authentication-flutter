 import 'package:supabase/supabase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

 SupabaseClient supabase = SupabaseClient(dotenv.env["SUPABASE_URL"]!, dotenv.env["SUPABASE_PUBLIC_ANON"]!);