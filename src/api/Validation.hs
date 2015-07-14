{-# LANGUAGE OverloadedStrings #-}

module Api.Validation where

import           Text.Digestive
import           Api.DataTypes
import           Data.Text (Text)
import           Data.Scientific (Scientific)
import           Data.Ratio (denominator, numerator)

validateInteger :: Num a => Scientific -> Result Text a
validateInteger x =
  let xRat = toRational x
  in if denominator xRat /= 1
       then Error "Number must be an integer"
       else return (fromInteger $ numerator xRat)

parseInteger :: (Monad m, Num a) => Form Text m a
parseInteger =
  validate validateInteger (stringRead "Could not parse number" Nothing)

reportForm :: Monad m => Form Text m Report
reportForm = Report 
  <$> "id" .: parseInteger
  <*> "name" .: stringRead "name must be a string"  Nothing
  <*> "description" .: stringRead "description must be a string" Nothing
  <*> "effort" .: parseInteger

