{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module DataTypes where

import           Control.Lens
import           Control.Monad.State.Class
import           Snap.Snaplet
import           Control.Monad.Reader
import           Snap.Snaplet.Heist
import           Snap.Snaplet.PostgresqlSimple


data Api = Api { _pg :: Snaplet Postgres }

makeLenses ''Api

data App = App { _heist :: Snaplet (Heist App), _api :: Snaplet Api}

makeLenses ''App

instance HasHeist App where
  heistLens = subSnaplet heist

instance HasPostgres (Handler b Api) where
  getPostgresState = with pg get
  setLocalPostgresState s = local (set (pg . snapletValue) s)