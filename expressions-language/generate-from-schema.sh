# To run this antlr4 needs to be installed locally. See https://github.com/antlr/antlr4-tools

antlr4 -Dlanguage=CSharp -o ../backend/API/Features/Expressions/Parser -no-listener -visitor -package API.Features.Expressions.Parser Expressions.g4
rm ../backend/API/Features/Expressions/Parser/*.interp ../backend/API/Features/Expressions/Parser/*.tokens

antlr4 -Dlanguage=Dart -o ../app/lib/common/expressions/parser -no-listener -visitor Expressions.g4
rm ../app/lib/common/expressions/parser/*.interp ../app/lib/common/expressions/parser/*.tokens
(cd ../app && fvm dart format lib/common/expressions/parser/*.dart)

cp Expressions.g4 ../web/bereich-a
(cd ../web/bereich-a && pnpm antlr4ng -Dlanguage=TypeScript -o src/lib/expressions/parser -no-listener -visitor Expressions.g4)
rm ../web/bereich-a/Expressions.g4
rm ../web/bereich-a/src/lib/expressions/parser/*.interp ../web/bereich-a/src/lib/expressions/parser/*.tokens
echo "// eslint-disable-next-line @typescript-eslint/ban-ts-comment\n// @ts-nocheck\n$(cat ../web/bereich-a/src/lib/expressions/parser/ExpressionsParser.ts)" > ../web/bereich-a/src/lib/expressions/parser/ExpressionsParser.ts
(cd ../web/bereich-a && pnpm eslint --fix --no-ignore src/lib/expressions/parser/*.ts)
