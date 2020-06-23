import gleam/option.{Some, None}
import gleam/regex.{FromStringError, Match, Options}
import gleam/should

pub fn from_string_test() {
  assert Ok(re) = regex.from_string("[0-9]")

  regex.match(re, "abc123")
  |> should.equal(True)

  regex.match(re, "abcxyz")
  |> should.equal(False)

  assert Error(from_string_err) = regex.from_string("[0-9")

  from_string_err
  |> should.equal(
    FromStringError(
      error: "missing terminating ] for character class",
      index: 4,
    ),
  )
}

pub fn from_string_with_test() {
  let options = Options(case_insensitive: True, multi_line: False)
  assert Ok(re) = regex.from_string_with(options, "[A-B]")

  regex.match(re, "abc123")
  |> should.equal(True)

  let options = Options(case_insensitive: False, multi_line: True)
  assert Ok(re) = regex.from_string_with(options, "^[0-9]")

  regex.match(re, "abc\n123")
  |> should.equal(True)
}

pub fn match_test() {
  assert Ok(re) = regex.from_string("^f.o.?")

  regex.match(re, "foo")
  |> should.equal(True)

  regex.match(re, "boo")
  |> should.equal(False)
}

pub fn split_test() {
  assert Ok(re) = regex.from_string(" *, *")

  regex.split(re, "foo,32, 4, 9  ,0")
  |> should.equal(["foo", "32", "4", "9", "0"])
}

pub fn scan_test() {
  assert Ok(re) = regex.from_string("[oi]n a(.?) (\\w+)")

  regex.scan(re, "I am on a boat in a lake.")
  |> should.equal(
    [
      Match(
        match: "on a boat",
        index: 5,
        number: 1,
        submatches: [None, Some("boat")],
      ),
      Match(
        match: "in a lake",
        index: 15,
        number: 2,
        submatches: [None, Some("lake")],
      ),
    ],
  )
}