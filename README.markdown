% Site planning
% 2017‒06‒18
% K B Dave

# Site proper

## Model

* Metadata schema from schema.org

ImageObject
  creator PersonId (not needed)
  fileFormat Text
  dateCreated UTCTime
  dateModified UTCTime
  description Text
  identifier Text
  UniqueImageObject identifier
  text ByteString

Person
  description Text
  identifier Text
  UniquePerson identifier
  image ImageObjectId Maybe
  name Text
  deriving Show

Blog
  description Text
  identifier Text
  UniqueBlog identifier
  name Text

BlogBlogPost
  blogId BlogId
  blogPostingId BlogPostingId
  UniqueBlogBlogPost blogId blogPostingId

BlogPosting
  dateCreated UTCTime
  dateModified UTCTime
  description Text
  identifier Text
  keywords Text
  UniqueBlogPosting identifier
  text Text
  thumbnailURL ImageObjectId Maybe

(not needed)
BlogPostingAuthor
  blogPostingId BlogPostingId
  personId PersonId
  UniqueBlogPostingAuthor blogPostingId personId

## View

* Research meta.plasm.us
* Write stylesheet
