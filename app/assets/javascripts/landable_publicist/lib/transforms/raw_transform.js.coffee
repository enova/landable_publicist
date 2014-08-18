# "raw" datatype; used for native json types that aren't supported in ember-data
Publicist.RawTransform = DS.Transform.extend
  deserialize: (serialized) -> serialized
  serialize: (deserialized) -> deserialized
