module.exports = Ember.Component.extend
  classNames: ['pagination']
  pages: (->
    needAddStart = 0
    needAddEnd = 0
    curPageNum = Number @get('curPageNum')
    pageSize = Number @get("pageSize")
    sortBy = @get 'sortBy'
    sortOrder = @get 'sortOrder'
    l = Number @get("allCount")
    pagesCount = Math.ceil(l / pageSize)

    pStart = curPageNum - 5
    if pStart < 1
      needAddEnd = 1 - pStart
      pStart = 1

    pEnd = curPageNum + 5
    if pEnd > pagesCount
      needAddStart = pEnd - pagesCount
      pEnd = pagesCount

    pStart -= needAddStart
    pEnd += needAddEnd
    pStart = 1 if pStart < 1
    pEnd = pagesCount if pEnd > pagesCount

    pEnd = 1 if pEnd < 1

    pagesArray = for pageNum in [pStart..pEnd]
      {pageNum, active: pageNum==curPageNum}

    pPrev = no
    if pStart > 1
      pPrev = pStart - 6
      pPrev = 1 if pPrev < 1

    pNext = no
    if pEnd < pagesCount
      pNext = pEnd + 6
      pNext = pagesCount if pNext > pagesCount

    pFirst = if pStart > 1 then 1 else no
    pLast = if pEnd < pagesCount then pagesCount else no

    @setProperties {pPrev, pNext, pFirst, pLast}

    pagesArray
  ).property "pageSize", "allCount", 'curPageNum'

  isVisible: (->
    pages = @get 'pages'
    pages.length > 1
  ).property 'pages'

