{-# LANGUAGE OverloadedStrings #-}

module Api.DataTypes where

import           Database.PostgreSQL.Simple.FromRow
import           Database.PostgreSQL.Simple.ToRow
import           Database.PostgreSQL.Simple.ToField
import           Data.Aeson
import           Data.Text (Text)
import           Control.Monad

data Report = Report { reportId :: Int
                     , name :: Text
                     , description :: Maybe Text
                     , effort :: Int} deriving (Show)

instance FromRow Report where
  fromRow = Report <$> field <*> field <*> field <*> field

instance ToRow Report where
  toRow d = [toField (reportId d), toField (name d), toField (description d), toField (effort d)]

instance ToJSON Report where
  toJSON (Report r n d e) = object [ "id" .= r, "name" .= n, "description" .= d, "effort" .= e ]

instance FromJSON Report where
  parseJSON (Object v) = Report <$>
                         v .: "id" <*>
                         v .: "name" <*>
                         v .:? "description" <*>
                         v .: "effort"
  parseJSON _ = mzero



data Student = Student { firstName :: String
                       , lastName :: String
                       , studentEffort :: Int } deriving (Show)


instance ToJSON Student where
  toJSON (Student sFName sLName sEff) = object ["firstName" .= sFName, "lastName" .= sLName, "effort" .= sEff]

instance FromJSON Student where
  parseJSON (Object v) = Student <$>
                         v .: "firstName" <*>
                         v .: "lastName" <*>
                         v .: "effort"
  parseJSON _ = mzero