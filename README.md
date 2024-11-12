# Nokhte

Nokhte is open-source mobile app that helps people collaborate in person.

Currently, the app has a solo session that allows individuals to take notes and see how long they are speaking.

There are also group sessions that:
1. make everyone join the session at the same time.
2. prevent interruptions between people.
3. lock app functionality if anyone goes offline during the meeting.

![app store marketing](https://github.com/user-attachments/assets/d7a22683-17f3-4774-baea-42a700932e7a)



## Contributing
If you want to contribute please contact me at my work email sonny@nokhte.com and we can get you started.

## Repository Structure

```markdown
src/packages
--------backend/dart
                | lib/table/query.dart
                | lib/table/stream.dart
                | test/table_test.dart
                | ...
--------backend/supabase
                | migrations.sql
                | functions/edge_function/index.ts
                | ...
--------client
           | lib/main.dart 
           | lib/app/
                   | modules/
                        | settings/..
                        | home/..
                        | login/..
                        | .../..
                    
                   | core/
                        | widgets/..
                        | modules/..
                        | .../..
           | test
               | test.dart

```

## Local Development
1. clone your forked GitHub repository
      ```sh
   git clone https://github.com/<github_username>/supabase.git
   ```
2. Go to the backend directory and start supabase
      ```sh
   cd packages/backend && cp .example.env .env && supabase start
    # copy backend env & start supabase
   ```
3. Install client dependencies
      ```sh
   cd ../client && cp .example.env .env && flutter pub get
      # copy client env & get dependencies
   ```
4. Fill out both backend & client env files
5. Run the client app
      ```sh
   flutter run
   ```
## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
