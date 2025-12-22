import 'package:clean_architecture/core/data/models/domain_convertible.dart';
import 'package:clean_architecture/features/{{feature.snakeCase()}}/domain/entities/test_user.dart';

{{#entity}}
class {{name.pascalCase()}}Response implements DomainConvertible<{{name.pascalCase()}}> {
  const {{name.pascalCase()}}Response({
    {{#variables}}
    required this.{{name.camelCase()}},
    {{/variables}}
  });
  
  {{#variables}}
  final {{{type}}} {{name.camelCase()}};
  {{/variables}}


  @override
  {{name.pascalCase()}} toDomain() {
    return {{name.pascalCase()}}(
      {{#variables}}
      {{name.camelCase()}}: {{name.camelCase()}},
      {{/variables}}
    );
  }
}
{{/entity}}