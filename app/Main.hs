--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Control.Monad (liftM)
import Data.Monoid (mappend, (<>))
import Hakyll
import Text.Pandoc.Options 
import Skylighting.Styles (tango)

--------------------------------------------------------------------------------

main :: IO ()
main = hakyllWith (defaultConfiguration { previewPort = 3000 } ) $ do
    match "content/images/*" $ do
        route   stripContent
        compile copyFileCompiler
    match "content/images/teaser/*" $ do
        route   stripContent
        compile copyFileCompiler

    match "style/images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "style/css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["content/about.markdown", "content/contact.markdown"]) $ do
        route   $ stripContent `composeRoutes` setExtension "html"
        compile $ myPandocCompiler
            >>= loadAndApplyTemplate "templates/title.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "content/posts/*.markdown" $ do
        route $ stripContent `composeRoutes` setExtension "html"
        compile $ myPandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "content/posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/title.html" archiveCtx 
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "content/index.html" $ do
        route stripContent
        compile $ do
            allPosts <- recentFirst =<< loadAll "content/posts/*"
            let mostRecent = take 10 allPosts
            let indexCtx =
                    listField "posts" postCtx (return mostRecent) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*.html" $ compile templateBodyCompiler
    match "templates/*.csl" $ compile cslCompiler
    match "content/bib/*.bib" $ compile biblioCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%Y‒%m‒%d" `mappend`
    defaultContext
--------------------------------------------------------------------------------
--
--From https://github.com/travisbrown/metaplasm/blob/master/app/Main.hs 
stripContent :: Routes
stripContent = gsubRoute "content/" $ const ""

myPandocCompiler :: Compiler (Item String)
myPandocCompiler = do
    csl <- load $ fromFilePath "templates/chicago-author-date.csl"
    bib <- load $ fromFilePath "content/bib/global.bib"
    liftM (writePandocWith myWriterOptions)
        (getResourceBody >>= readPandocBiblio def csl bib)
    where
      myWriterOptions = defaultHakyllWriterOptions {
          writerTabStop = 2
        , writerCiteMethod = Citeproc
        , writerVariables = [
          ("link-citations", "true")
          ]
        , writerColumns = 80
        , writerHighlight = True
        , writerHighlightStyle = tango
        }
