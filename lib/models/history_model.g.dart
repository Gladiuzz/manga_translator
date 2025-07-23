// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHistoryModelCollection on Isar {
  IsarCollection<HistoryModel> get historyModels => this.collection();
}

const HistoryModelSchema = CollectionSchema(
  name: r'HistoryModel',
  id: 5151902556644193383,
  properties: {
    r'imagePaths': PropertySchema(
      id: 0,
      name: r'imagePaths',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 1,
      name: r'title',
      type: IsarType.string,
    ),
    r'translateDate': PropertySchema(
      id: 2,
      name: r'translateDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _historyModelEstimateSize,
  serialize: _historyModelSerialize,
  deserialize: _historyModelDeserialize,
  deserializeProp: _historyModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _historyModelGetId,
  getLinks: _historyModelGetLinks,
  attach: _historyModelAttach,
  version: '3.1.0+1',
);

int _historyModelEstimateSize(
  HistoryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.imagePaths.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _historyModelSerialize(
  HistoryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.imagePaths);
  writer.writeString(offsets[1], object.title);
  writer.writeDateTime(offsets[2], object.translateDate);
}

HistoryModel _historyModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HistoryModel();
  object.id = id;
  object.imagePaths = reader.readString(offsets[0]);
  object.title = reader.readString(offsets[1]);
  object.translateDate = reader.readDateTime(offsets[2]);
  return object;
}

P _historyModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _historyModelGetId(HistoryModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _historyModelGetLinks(HistoryModel object) {
  return [];
}

void _historyModelAttach(
    IsarCollection<dynamic> col, Id id, HistoryModel object) {
  object.id = id;
}

extension HistoryModelQueryWhereSort
    on QueryBuilder<HistoryModel, HistoryModel, QWhere> {
  QueryBuilder<HistoryModel, HistoryModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HistoryModelQueryWhere
    on QueryBuilder<HistoryModel, HistoryModel, QWhereClause> {
  QueryBuilder<HistoryModel, HistoryModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HistoryModelQueryFilter
    on QueryBuilder<HistoryModel, HistoryModel, QFilterCondition> {
  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      imagePathsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      imagePathsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      imagePathsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      imagePathsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePaths',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      imagePathsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      imagePathsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      imagePathsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      imagePathsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePaths',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      imagePathsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePaths',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      imagePathsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePaths',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      translateDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translateDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      translateDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translateDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      translateDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translateDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterFilterCondition>
      translateDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translateDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HistoryModelQueryObject
    on QueryBuilder<HistoryModel, HistoryModel, QFilterCondition> {}

extension HistoryModelQueryLinks
    on QueryBuilder<HistoryModel, HistoryModel, QFilterCondition> {}

extension HistoryModelQuerySortBy
    on QueryBuilder<HistoryModel, HistoryModel, QSortBy> {
  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy> sortByImagePaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePaths', Sort.asc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy>
      sortByImagePathsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePaths', Sort.desc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy> sortByTranslateDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translateDate', Sort.asc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy>
      sortByTranslateDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translateDate', Sort.desc);
    });
  }
}

extension HistoryModelQuerySortThenBy
    on QueryBuilder<HistoryModel, HistoryModel, QSortThenBy> {
  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy> thenByImagePaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePaths', Sort.asc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy>
      thenByImagePathsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePaths', Sort.desc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy> thenByTranslateDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translateDate', Sort.asc);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QAfterSortBy>
      thenByTranslateDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translateDate', Sort.desc);
    });
  }
}

extension HistoryModelQueryWhereDistinct
    on QueryBuilder<HistoryModel, HistoryModel, QDistinct> {
  QueryBuilder<HistoryModel, HistoryModel, QDistinct> distinctByImagePaths(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePaths', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryModel, HistoryModel, QDistinct>
      distinctByTranslateDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translateDate');
    });
  }
}

extension HistoryModelQueryProperty
    on QueryBuilder<HistoryModel, HistoryModel, QQueryProperty> {
  QueryBuilder<HistoryModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HistoryModel, String, QQueryOperations> imagePathsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePaths');
    });
  }

  QueryBuilder<HistoryModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<HistoryModel, DateTime, QQueryOperations>
      translateDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translateDate');
    });
  }
}
