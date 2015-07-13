{-# LANGUAGE OverloadedStrings #-}

module Api.Core where

import           Snap.Snaplet.PostgresqlSimple
import           Snap.Core
import           Snap.Snaplet
import           DataTypes
import qualified Data.ByteString.Char8 as B
import           Api.Reports
import           Api.Generation


apiRoutes :: [(B.ByteString, Handler b Api ())]
apiRoutes = [ ("reports",  method GET getReports)
             ,("reports/:reportId", method GET getReport)
             ,("reports", method POST createReport)
             ,("generate", method POST generateReports)
            ]
  

apiInit :: SnapletInit b Api
apiInit = makeSnaplet "api" "Api Endpoints" Nothing $ do
  pgSnaplet <- nestSnaplet "pg" pg pgsInit
  addRoutes apiRoutes
  return $ Api pgSnaplet

