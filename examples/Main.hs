{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

import Yesod
import Yesod.GitRev

data Master = Master
  { getGitRev :: GitRev
  }

mkYesod "Master" [parseRoutes|
/build-version GitRevR GitRev getGitRev
|]

instance Yesod Master

main = warp 3000 $ Master $$(tGitRev)
