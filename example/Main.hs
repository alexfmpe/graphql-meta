{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE TypeApplications  #-}
{-# LANGUAGE QuasiQuotes       #-}
--------------------------------------------------------------------------------
-- |
-- Module      : Main
-- Description : Example usage of graphql-meta
-- Maintainer  : David Johnson <david@urbint.com>, Ryan Schmukler <ryan@urbint.com>
-- Maturity    : Usable
--
--------------------------------------------------------------------------------
module Main (main) where
--------------------------------------------------------------------------------
import           GHC.Generics
import qualified Data.Text as T
import           Data.Text    (Text)
import qualified Data.Text.Encoding as T
import           Data.Proxy
--------------------------------------------------------------------------------
import           GraphQL.QQ
import           GraphQL.Parser
import           GraphQL.Generic
import           GraphQL.AST
import           GraphQL.Pretty
--------------------------------------------------------------------------------
-- | Produces the following results when using QuasiQuotation and Generics
-- @
-- {
--    building(param:"uuid-goes-here") {
--      floorCount    height
--   }
-- }
-- query WhoHah($id: String ) {
--    building(id:"test") {
--      floorCount
--   }
-- }
-- type Person{name:String!,age:Int!}
-- @
main :: IO ()
main = do
  pPrint buildingExample
  pPrint (singleSubstitution "test")
  showPersonSchema
    where
      pPrint = print . printExecutableDefinition

-- | QuasiQuotation substitution example
buildingExample :: ExecutableDefinition
buildingExample
  = multipleSubstitution "building" "uuid-goes-here" "floorCount" "height"

-- | QuasiQuotation multiple substitutions example
multipleSubstitution
  :: String
  -> String
  -> String
  -> String
  -> ExecutableDefinition
multipleSubstitution
  = undefined

-- | QuasiQuotation single substitution example
singleSubstitution
  :: String
  -> ExecutableDefinition
singleSubstitution
  = undefined

lol :: Either String ExecutableDefinition
lol = exeDef
    $ T.encodeUtf8
    $ T.pack
    $ show
    $ printExecutableDefinition [query| { building { floorCount } } |]

-- | Example of using GHC.Generics to create a Schema from a product type
data Person = Person
  { name :: String
  , age  :: Int
  } deriving (Show, Eq, Generic)

instance ToObjectTypeDefinition Person

showPersonSchema :: IO ()
showPersonSchema = print $ toObjectTypeDefinition (Proxy @ Person)

