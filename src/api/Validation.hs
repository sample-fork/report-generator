{-# LANGUAGE OverloadedStrings #-}

module Api.Validation where

import           Text.Digestive
import           Api.DataTypes
import qualified Data.Text as T
import           Data.Scientific (Scientific)
import           Data.Ratio (denominator, numerator)

validateInteger :: Num a => Scientific -> Result T.Text a
validateInteger x =
  let xRat = toRational x
  in if denominator xRat /= 1
       then Error "Number must be an integer"
       else return (fromInteger $ numerator xRat)

parseInteger :: (Monad m, Num a) => Form T.Text m a
parseInteger =
  validate validateInteger (stringRead "Could not parse number" Nothing)

isNotEmpty :: T.Text -> Bool
isNotEmpty = not . T.null

reportForm :: Monad m => Form T.Text m Report
reportForm = Report 
  <$> "id" .: parseInteger
  <*> "name" .: check "Name is required" isNotEmpty (text Nothing)
  <*> "description" .: optionalText Nothing
  <*> "effort" .: parseInteger


studentForm :: Monad m => Form T.Text m Student
studentForm = Student 
  <$> "firstName" .: check "First name is required" isNotEmpty (text Nothing)
  <*> "lastName" .: check "Last name is required" isNotEmpty (text Nothing)
  <*> "effort" .: parseInteger