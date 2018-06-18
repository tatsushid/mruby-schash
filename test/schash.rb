assert('Schash::Validator#validate: with invalid data') do
  validator = Schash::Validator.new do
    {
      data: {
        string: string,
        not_string: string,
        words: array_of(string),
        not_array: array_of(string),
        required_missing: string,
        optional_missing: optional(string),
        optional_type_error: optional(string),
        numeric: numeric,
        not_numeric: numeric,
        hash: {
          required_missing: string,
        },
        array_of_hash: array_of({
          required_missing: string,
        }),
        boolean: boolean,
        not_boolean: boolean,
        match: match(/^pattern$/),
        not_match: match(/^pattern$/)
      }
    }
  end

  errors = validator.validate({
    data: {
      string: "string",
      not_string: 1,
      words: [1],
      not_array: 1,
      optional_type_error: 1,
      numeric: 1,
      not_numeric: "not numeric",
      hash: {
      },
      array_of_hash: [{}],
      boolean: true,
      not_boolean: "string",
      match: "pattern",
      not_match: "not match pattern"
    },
  })

  expected = [
    [
      ["data", "not_string"],
      "is not String",
    ],
    [
      ["data", "words", 0],
      "is not String",
    ],
    [
      ["data", "not_array"],
      "is not an array",
    ],
    [
      ["data", "required_missing"],
      "is required but missing",
    ],
    [
      ["data", "optional_type_error"],
      "is not String",
    ],
    [
      ["data", "not_numeric"],
      "is not Numeric",
    ],
    [
      ["data", "hash", "required_missing"],
      "is required but missing",
    ],
    [
      ["data", "array_of_hash", 0, "required_missing"],
      "is required but missing",
    ],
    [
      ["data", "not_boolean"],
      "is not any of TrueClass, FalseClass",
    ],
    [
      ["data", "not_match"],
      "does not match /^pattern$/",
    ]
  ]

  assert_equal expected.size, errors.size
  errors.each_with_index do |error, i|
    assert_equal expected[i][0], error.position
    assert_equal expected[i][1], error.message
  end
end

assert('Schash::Validator#validate: optional hash') do
  validator = Schash::Validator.new do
    {
      foo: {
        bar: optional({
          baz: string,
        }),
      },
    }
  end

  [
    [{foo: {}}, []],
    [{foo: {qux: 1}}, []],
    [{foo: {bar: {}}}, [[["foo", "bar", "baz"], "is required but missing"]]],
    [{foo: {bar: {baz: 1}}}, [[["foo", "bar", "baz"], "is not String"]]],
  ].each do |data, expected|
    errors = validator.validate(data)
    assert_equal expected.size, errors.size
    errors.each_with_index do |error, i|
      assert_equal expected[i][0], error.position
      assert_equal expected[i][1], error.message
    end
  end
end

assert('Schash::Validator#validate: is not Hash error') do
  validator = Schash::Validator.new do
    {
      foo: {
        bar: optional({
          baz: string,
        }),
      },
    }
  end

  [
    [{foo: {}}, []],
    [{foo: 1}, [[["foo"], "is not Hash"]]],
    [{foo: nil}, [[["foo"], "is not Hash"]]],
    [{foo: {bar: {baz: "a"}}}, []],
    [{foo: {bar: 1}}, [[["foo", "bar"], "is not Hash"]]],
    [{foo: {bar: nil}}, [[["foo", "bar"], "is not Hash"]]],
  ].each do |data, expected|
    errors = validator.validate(data)
    assert_equal expected.size, errors.size
    errors.each_with_index do |error, i|
      assert_equal expected[i][0], error.position
      assert_equal expected[i][1], error.message
    end
  end
end

assert('Schash::Validator#validate: with MapOf rule') do
  validator = Schash::Validator.new do
    {
      foo: map_of(
        symbol, {
          bar: string,
        }
      ),
    }
  end

  [
    [
      {foo: {}},
      [],
    ],
    [
      {foo: 1},
      [[["foo"], "is not Map"]],
    ],
    [
      {foo: nil},
      [[["foo"], "is not Map"]],
    ],
    [
      {foo: {baz: {bar: "a"}}},
      [],
    ],
    [
      {foo: {'baz' => {bar: "a"}}},
      [[["foo", "baz key"], "is not Symbol"]],
    ],
    [
      {foo: {baz: {bar: 1}}},
      [[["foo", "baz", "bar"], "is not String"]],
    ],
    [
      {foo: {baz: {bar: "a"}, qux: {bar: "b"}}},
      [],
    ],
    [
      {foo: {baz: {bar: "a"}, 'qux' => {bar: "b"}}},
      [[["foo", "qux key"], "is not Symbol"]],
    ],
    [
      {foo: {baz: {bar: "a"}, qux: {bar: 1}}},
      [[["foo", "qux", "bar"], "is not String"]],
    ],
  ].each do |data, expected|
    errors = validator.validate(data)
    assert_equal expected.size, errors.size
    errors.each_with_index do |error, i|
      assert_equal expected[i][0], error.position
      assert_equal expected[i][1], error.message
    end
  end
end
