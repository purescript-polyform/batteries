module Test.Main where

import Prelude

import Effect (Effect)
import Test.Polyform.Decimal (suite) as Test.Polyform.Decimal
import Test.Unit.Main (runTest)
import Test.Polyform.Json.Validators (suite) as Test.Polyform.Json.Validators
-- import Test.Polyform.Json.Validators.Duals (suite) as Test.Polyform.Json.Validators.Duals

main ∷ Effect Unit
main = runTest $ do
  Test.Polyform.Decimal.suite
  Test.Polyform.Json.Validators.suite
  -- Test.Polyform.Json.Validators.Duals.suite

-- import Data.Argonaut (fromBoolean, fromNumber) as Argonaut
-- import Data.Argonaut (fromBoolean, fromNumber, fromObject, fromString, stringify, toObject)
-- import Data.Argonaut (fromString, stringify) as Argounaut
-- import Data.Argonaut.Core (Json)
-- import Data.Generic.Rep (class Generic)
-- import Data.Generic.Rep.Show (genericShow)
-- import Data.Int (toNumber)
-- import Data.Map as Map
-- import Data.Maybe (Maybe(..))
-- import Data.Newtype (unwrap)
-- import Data.Tuple (Tuple(..))
-- import Data.Tuple.Nested ((/\))
-- import Data.Validation.Semigroup (invalid, unV)
-- import Data.Variant (Variant, case_, inj, match, on, onMatch)
-- import Debug.Trace (traceM)
-- import Effect (Effect)
-- import Effect.Aff (Aff)
-- import Effect.Class.Console (log)
-- import Foreign.Object (Object, fromFoldable) as Object
-- import Global.Unsafe (unsafeStringify)
-- import Polyform.Dual (Dual(..), DualD(..), dual, serializer, (~))
-- import Polyform.Dual.Generic (sum, variant) as Dual.Generic
-- import Polyform.Dual.Validator as Dual.Validator
-- import Polyform.Dual.Validator.Generic (sum, variant) as Dual.Validator.Generic
-- import Polyform.Dual.Validators.Json (ObjectDual, JsonDual, (:=))
-- import Polyform.Dual.Validators.Json (boolean, int, json, number, object, objectField, string, variant) as Dual.Json
-- import Polyform.Dual.Validators.Json (json, object) as Dual
-- import Polyform.Dual.Validators.UrlEncoded as Dual.Validators.UrlEncoded
-- import Polyform.Validator (Validator(..), hoistFn, hoistFnMV, hoistFnV, runValidator, valid)
-- import Polyform.Validators.Json (JsonError)
-- import Polyform.Validators.Json (Validator, JsonDecodingError, boolean, failure, field, int, jsType, json, string) as Json
-- import Polyform.Validators.UrlEncoded as UrlEncoded
-- import Test.Unit (failure, test)
-- import Test.Unit (suite) as Test.Unit
-- import Test.Unit.Assert (assert, equal)
-- import Test.Unit.Main (runTest)
-- import Type.Prelude (SProxy(..), reflectSymbol)
-- import Type.Row (type (+))
-- import Unsafe.Coerce (unsafeCoerce)
-- 
-- d ∷ ∀ e m. Monad m ⇒ ObjectDual m e { foo ∷ Int, bar ∷ String, baz ∷ Number }
-- d = Dual $ { foo: _, bar: _, baz: _ }
--   <$> (SProxy ∷ SProxy "foo") := Dual.Json.int
--   <*> (SProxy ∷ SProxy "bar") := Dual.Json.string
--   <*> (SProxy ∷ SProxy "baz") := Dual.Json.number
-- 
-- obj ∷ ∀ e. JsonDual
--   Aff
--   (JsonError + e)
--   { foo ∷ Int
--   , bar ∷ String
--   , baz ∷ Number
--   }
-- obj = Dual.Json.object >>> d
-- 
-- -- dualUrlEncoded ∷ ∀ e m. Monad m ⇒ Dual.Validators.UrlEncoded.Dual m e { foo ∷ Int, bar ∷ String, baz ∷ Number }
-- dualUrlEncoded = (Dual $ { foo: _, bar: _, baz: _ }
--   <$> _.foo ~ Dual.Validators.UrlEncoded.field "foo" Dual.Validators.UrlEncoded.int
--   <*> _.bar ~ Dual.Validators.UrlEncoded.field "bar" Dual.Validators.UrlEncoded.string
--   <*> _.baz ~ Dual.Validators.UrlEncoded.field "baz" Dual.Validators.UrlEncoded.number)
--   <<< Dual.Validators.UrlEncoded.query { replacePlus: false }
-- 
-- type SumV = Variant (s ∷ String, i ∷ Int, b ∷ Boolean )
-- _s = SProxy ∷ SProxy "s"
-- _i = SProxy ∷ SProxy "i"
-- _a = SProxy ∷ SProxy "a"
-- _b = SProxy ∷ SProxy "b"
-- _c = SProxy ∷ SProxy "c"
-- 
-- 
-- sumVariant = ({ t: _, v: _ } <$> Json.field "tag" Json.string <*> Json.field "value" Json.string) >>> (hoistFnMV $ case _ of
--   { t: "s", v } →  runValidator (Json.json >>> Json.string >>> hoistFn (inj _s)) v
--   { t: "i", v } → runValidator (Json.json >>> Json.int >>> hoistFn (inj _i)) v
--   { t: "b", v } → runValidator (Json.json >>> Json.boolean >>> hoistFn (inj _b)) v)
-- 
-- 
-- sumVariantDual ∷ ∀ e. JsonDual Aff (Json.JsonDecodingError e) SumV
-- sumVariantDual = Dual.object >>> tagWithValue >>> valueDual
--   where
--     tagWithValue = Dual $ { t: _, v: _ }
--       <$> _.t ~ Dual.Json.objectField "tag" Dual.Json.string
--       <*> _.v ~ Dual.Json.objectField "value" identity
-- 
--     parser = hoistFnMV $ case _ of
--       { t: "s", v } → runValidator (Json.string >>> hoistFn (inj _s)) v
--       { t: "i", v } → runValidator (Json.int >>> hoistFn (inj _i)) v
--       { t: "b", v } → runValidator (Json.boolean >>> hoistFn (inj _b)) v
--       { t, v } → pure $ Json.failure
--         ("Invalid tag: " <> t <> " with value: " <> (stringify v) )
-- 
--     serializer = match
--       { s: \s → { t: "s", v: Argounaut.fromString s }
--       , i: \i → { t: "i", v: Argonaut.fromNumber <<< toNumber $ i }
--       , b: \b → { t: "b", v: Argonaut.fromBoolean $ b }
--       }
-- 
--     valueDual = dual { parser, serializer }
-- 
-- data Sum = S String | I Int | B Boolean
-- derive instance genericSum ∷ Generic Sum _
-- derive instance eqSum ∷ Eq Sum
-- instance showSum ∷ Show Sum where
--   show = genericShow
-- 
-- data Single = Single String
-- derive instance genericSingle ∷ Generic Single _
-- 
-- field v = const v unit
-- 
-- sum' ∷
--   ∀ e m.
--   Monad m ⇒
--   Dual (Validator m _) _ Sum
-- sum' = Dual.Validator.Generic.sum
--   { "S": identity Dual.Json.string
--   , "I": identity Dual.Json.int
--   , "B": identity Dual.Json.boolean
--   }
-- 
-- genericVariantDual ∷
--   ∀ e i m.
--   Monad m ⇒
--   Dual (Validator m _) _ (Variant (a ∷ Boolean, b ∷ String, c ∷ Int, d ∷ String, e ∷ Int))
-- genericVariantDual = Dual.Json.variant
--   { "a": identity Dual.Json.boolean
--   , "b": identity Dual.Json.string
--   , "c": identity Dual.Json.int
--   , "d": identity Dual.Json.string
--   , "e": identity Dual.Json.int
--   }
-- 
-- -- sum ∷ ∀ m e. Monad m ⇒ Json.Validator m e (Object.Object Json)
-- sum = ({ t: _, v: _ } <$> Json.field "tag" Json.string <*> Json.field "value" Json.string) >>> (hoistFnMV $ case _ of
--   { t: "S", v } →  runValidator (Json.json >>> Json.string >>> hoistFn S) v
--   { t: "I", v } → runValidator (Json.json >>> Json.int >>> hoistFn I) v
--   { t: "B", v } → runValidator (Json.json >>> Json.boolean >>> hoistFn B) v)
-- 
-- sumDual ∷ ∀ e. JsonDual Aff (Json.JsonDecodingError e) Sum
-- sumDual = Dual.object >>> tagWithValue >>> valueDual
--   where
--     tagWithValue = Dual $ { t: _, v: _ }
--       <$> _.t ~ Dual.Json.objectField "tag" Dual.Json.string
--       <*> _.v ~ Dual.Json.objectField "value" identity
-- 
--     parser = hoistFnMV $ case _ of
--       { t: "S", v } → runValidator (Json.string >>> hoistFn S) v
--       { t: "I", v } → runValidator (Json.int >>> hoistFn I) v
--       { t: "B", v } → runValidator (Json.boolean >>> hoistFn B) v
--       { t, v } → pure $ Json.failure
--         ("Invalid tag: " <> t <> " with value: " <> (stringify v) )
-- 
--     serializer = case _ of
--       S s → { t: "S", v: Argounaut.fromString s }
--       I i → { t: "I", v: Argonaut.fromNumber <<< toNumber $ i }
--       B b → { t: "B", v: Argonaut.fromBoolean $ b }
-- 
--     valueDual = dual { parser, serializer }
-- 
-- main ∷ Effect Unit
-- main = runTest $ do
--   Test.Unit.suite "Validators.Urlencoded" $ do
--     test "decodes plus to space if option set" $ do
--       x ← runValidator (UrlEncoded.query { replacePlus: true }) "field1=some+text+with+spaces"
--       unV
--         (const $ failure "Validation failed")
--         (_ `equal` (Map.fromFoldable [Tuple "field1" ["some text with spaces"]]))
--         x
--     test "decodes plus as plus to space if option is unset" $ do
--       x ← runValidator (UrlEncoded.query { replacePlus: false }) "field1=some+text+with+spaces"
--       unV
--         (const $ failure "Validation failed")
--         (_ `equal` (Map.fromFoldable [Tuple "field1" ["some+text+with+spaces"]]))
--         x
--     test "decodes repeated value into array" $ do
--       x ← runValidator (UrlEncoded.query { replacePlus: false }) "arr=v1&arr=v2&arr=v3"
--       unV
--         (const $ failure "Validation failed")
--         (_ `equal` (Map.fromFoldable [Tuple "arr" ["v1", "v2", "v3"]]))
--         x
-- 
--     test "decodes fields" $ do
--       let
--         fields = { string: _, int: _, number: _, array: _, boolean: _ }
--           <$> UrlEncoded.field "string" UrlEncoded.string
--           <*> UrlEncoded.field "int" UrlEncoded.int
--           <*> UrlEncoded.field "number" UrlEncoded.number
--           <*> UrlEncoded.field "array" UrlEncoded.array
--           <*> UrlEncoded.field "boolean" UrlEncoded.boolean
-- 
--       x ← runValidator
--         (UrlEncoded.query { replacePlus: true } >>> fields)
--         "string=some+text&int=8&number=0.1&array=v1&array=v2&array=v3&boolean=on"
-- 
--       unV
--         (const $ failure "Validation failed")
--         (_ `equal` {string: "some text", int: 8, number: 0.1, array: ["v1", "v2", "v3"], boolean: true})
--         x
-- 
--   Test.Unit.suite "Dual" $ do
--     Test.Unit.suite "Json" $ do
--       test "serialization / validation" $ do
--         let
--           input = { foo: 8, bar: "test", baz: 8.0 }
--         let
--           xObj = fromObject $ Object.fromFoldable ["foo" /\ fromNumber (toNumber 8), "bar" /\ fromString "test", "baz" /\ fromNumber 8.0]
--         serialized ← Dual.Validator.runSerializer obj input
--         parsed ← Dual.Validator.runValidator obj xObj
--         let r = serialized == xObj
--         assert "Jsons are not equal" r
--         unV
--           (const $ failure "Validation failed")
--           (_ `equal` input)
--           parsed
-- 
--       test "serialization / validation of an example sum" $ do
--         let
--           input = B true
--         let
--           xObj = fromObject $ Object.fromFoldable [ "tag" /\ fromString "B", "value" /\ fromBoolean true ]
--         serialized ← Dual.Validator.runSerializer sumDual input
--         parsed ← Dual.Validator.runValidator sumDual xObj
--         let r = serialized == xObj
--         assert "Jsons are not equal" r
--         unV
--           (const $ failure "Validation failed")
--           (_ `equal` input)
--           parsed
-- 
--       test "serialization / validation of an example variant" $ do
--         let
--           input = inj _b true
--         let
--           xObj = fromObject $ Object.fromFoldable [ "tag" /\ fromString "b", "value" /\ fromBoolean true ]
--         serialized ← Dual.Validator.runSerializer sumVariantDual input
--         parsed ← Dual.Validator.runValidator sumVariantDual xObj
--         let r = serialized == xObj
--         assert "Jsons are not equal" r
--         unV
--           (const $ failure "Validation failed")
--           (_ `equal` input)
--           parsed
-- 
--       test "serialization / validation of generic duals for variants" $ do
--         let
--           input = inj _b "test"
--           xObj = fromObject $ Object.fromFoldable [ "tag" /\ fromString "b", "value" /\ fromString "test" ]
--         serialized ← Dual.Validator.runSerializer genericVariantDual input
--         serialized2 ← Dual.Validator.runSerializer genericVariantDual (inj _a true)
--         serialized3 ← Dual.Validator.runSerializer genericVariantDual (inj _c 8)
--         parsed ← Dual.Validator.runValidator genericVariantDual xObj
--         log $ unsafeStringify serialized
--         log $ unsafeStringify serialized2
--         log $ unsafeStringify serialized3
--         log $ unsafeStringify parsed
--         let r = serialized == xObj
--         assert "Jsons are not equal" r
--         unV
--           (const $ failure "Validation failed")
--           (_ `equal` input)
--           parsed
-- 
--     Test.Unit.suite "Urlencoded" $ do
--       test "serialization / validation" $ do
--         let
--           input = { foo: 8, bar: "test", baz: 8.2 }
--         serialized ← Dual.Validator.runSerializer dualUrlEncoded input
--         traceM serialized
--         let
--           qStr = Dual.Validators.UrlEncoded.Decoded $ Map.fromFoldable ["foo" /\ ["8"], "bar" /\ ["test"], "baz" /\ ["8.0"]]
--         parsed ← Dual.Validator.runValidator dualUrlEncoded "foo=8&bar=test&baz=8.2"
--         -- assert "Urlencoded maps are not equal" (serialized == qStr)
--         unV
--           (const $ failure "Validation failed")
--           (_ `equal` input)
--           parsed
