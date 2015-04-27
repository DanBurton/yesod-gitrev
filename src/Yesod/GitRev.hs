{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Yesod.GitRev
  ( GitRev (..)
  , gitRev
  , tGitRev
  ) where

import Yesod.Core
import Yesod.GitRev.Data

getGitRevR :: Yesod master => HandlerT GitRev (HandlerT master IO) Html
getGitRevR = getYesod >>= \GitRev{..} -> lift $ do
  defaultLayout $ do
    [whamlet|
      Hash: #{gitRevHash}<br />
      Branch: #{gitRevBranch}<br />
      Dirty: #{gitRevDirty}
    |]

instance Yesod master => YesodSubDispatch GitRev (HandlerT master IO) where
  yesodSubDispatch = $(mkYesodSubDispatch resourcesGitRev)
