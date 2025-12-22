import 'package:equatable/equatable.dart';

{{#entity}}
class {{name.pascalCase()}} extends Equatable {
  const {{name.pascalCase()}}({
    {{#variables}}
    required this.{{name.camelCase()}},
    {{/variables}}
  });

  {{#variables}}
  final {{{type}}} {{name.camelCase()}};
  {{/variables}}

  @override
  List<Object?> get props => [
    {{#variables}}
    {{name.camelCase()}},
    {{/variables}}
  ];
}
{{/entity}}