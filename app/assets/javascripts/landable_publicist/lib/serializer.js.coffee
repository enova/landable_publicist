Publicist.ApplicationSerializer = DS.ActiveModelSerializer.extend

  # Landable expects either a correct class name (e.g. 'Landable::Page') or
  # what ember calls a type key (e.g. 'page'), so we're sticking with the
  # underscored type for now.
  serializePolymorphicType: (record, json, relationship) ->
    key = relationship.key
    belongsTo = record.get(key)

    key = this.keyForAttribute(key)

    json["#{key}_type"] = belongsTo.constructor.typeKey.underscore()

  normalizePayload: (type, payload) ->
    normalizedPayload = {}

    for key, value of payload
      normalizedPayload[key.camelize()] = value

    normalizedPayload