import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

class ApiInfoView extends StatelessWidget {
  const ApiInfoView({super.key});

  static const String endpoint = 'https://onepieceql.up.railway.app/graphql';

  static const String query = '''
  query Characters {
    characters {
      results {
        englishName
        age
        birthday
        bounty
        devilFruitName
        avatarSrc
      }
    }
  }
  ''';

  static const String sampleJson = '''
  {
    "data": {
      "characters": {
        "results": [
          {
            "englishName": "Monkey D. Luffy",
            "age": 19,
            "birthday": "May 5",
            "bounty": "3,000,000,000",
            "devilFruitName": "Gomu Gomu no Mi",
            "avatarSrc": "https://.../luffy.jpg"
          }
        ]
      }
    }
  }
  ''';

  @override
  Widget build(BuildContext context) {
    return const BaseView(
      title: 'OnePieceQL - API Info',
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Endpoint:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              SelectableText(endpoint),
              SizedBox(height: 16),
              Text(
                'Query utilizada:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              SelectableText(query),
              SizedBox(height: 16),
              Text(
                'Respuesta JSON (fragmento):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              SelectableText(sampleJson),
            ],
          ),
        ),
      ),
    );
  }
}
