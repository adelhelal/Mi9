# Mi9 - Vote Service

## Process

- **GET/questions/parentId**
    - Retrieve question & answers metadata from sitecore
    - Retrieve answer's results from datastore
    - Results are appended to answer metadata
        - Add results to seed
    - Return as json
- **GET/questions/:questionIds**
    - Retrieve question & answers metadata from sitecore
    - Retrieve answer's results from datastore
    - Results are appended to answer metadata
        - Add results to seed
    - Return as json
- **POST/vote/:questionId/:answerId**
    - Increment answer count
        - Store answer's results
    - Retrieve question & answers metadata from sitecore
    - Retrieve answer's results from datastore
    - Results are appended to answer metadata
        - Add results to seed
    - Return as json

## Prerequisites

- node
- grunt
- coffee

## Specifications

- **question**
    - active (boolean)
    - can vote (boolean)
    - percentage | numeric
    - image
    - hide results (boolean)
        - thank you text

- **answer**
    - value
    - image
    - seed

## Examples

Get question by home node
<pre>
    # GET /network/QuestionsByParent/DD34F5E4-7E1D-4D18-8B2C-5C05C07BB50C
</pre>

Get question by folder node
<pre>
    # GET /network/QuestionsByParent/07902093-D07B-4DE5-9265-08D27929B550
</pre>

Get question by comma separated list of ids
<pre>
    # GET /network/QuestionsByIds/DB887497-3B47-4E18-92E3-C2D7427133DB,06E51721-05F9-4630-9941-2EA8CFB6B2BD
</pre>

## Tasks

- Log answer
- Concurrency
    - Cleanup schedule for multiple concurrent inserts
- Cache
    - read sitecore (10 mins expiry)
    - read datastore (1 mins expiry)
- Spamming protection
    - Timestamp
    - IP
    - HMAC
    - Session
- Load testing
- Source of votes ?
- Exporting Aircast ?
