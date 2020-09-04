# Prompt
# Please write a query in either SQL or ActiveRecord (as actual code or pseudo-code, depending on your preference) to answer each of the following questions:

# Find the ids of all documents which do not have any pages.
# Return a list of report titles and the total number of pages in the report. Reports which do not have pages may be ignored.
# How would you determine the percentage of document pages which include a footnote?
# How would you search the body of a page to look for a specific search string? Any approach is welcome, though you may only use native methods, not gems or other libraries.

def prompt1
  sql = "
  SELECT documents.id 
  FROM documents 
  LEFT OUTER JOIN pages 
    ON pages.document_id = documents.id 
  WHERE pages.id IS NULL
  "

  ActiveRecord::Base.connection.execute(sql)
end

def prompt2
  sql = "
  SELECT reports.title,COUNT(reports.id) 
  FROM reports
  LEFT OUTER JOIN (
      SELECT documents.report_id, documents.id 
      FROM documents
      LEFT OUTER JOIN pages 
        ON pages.document_id = documents.id 
      WHERE pages.id IS NOT NULL
    ) as doc_counts 
    ON doc_counts.report_id = reports.id 
  WHERE doc_counts.report_id > 0 
  GROUP BY doc_counts.report_id
  "

  ActiveRecord::Base.connection.execute(sql)
end

# You could do a fancy query with COUNT and SUM, but I felt this is the most reasonable approach. 
# This also removes the need to rely on checking for a zero dividend within your SQL queries.
def prompt3
  if Page.count < 1:
    return 0
  end
  return (Page.where("footnote IS NOT NULL").count / Page.count)
end

# This was very open ended. There are a few contexts in which you may want to look.
# I considered what I would probably want, and decided on this:
# - each match
# - not case sensitive
# - looking for a simple string

# Note that this will not work with special characters. If you want something more
# complex, I implemented something similar in JS not too long ago:
# https://github.com/elliott-king/resume-compare/blob/fde7d56425cc8892aa20acf39fcd982bdb6a490e/src/compare/compare.js#L5
def prompt4(search_string, page)
  body = page.body
  body.scan(/\b#{search_string}\b/i)
end