module.exports = Ember.Component.extend
  #showPaginator: yes
  pages: (->
    needAddStart = 0
    needAddEnd = 0
    curPageNum = Number @get('curPageNum')
    pageSize = Number @get("pageSize")
    l = Number @get("allCount")
    pagesCount = Math.ceil(l / pageSize)

    pStart = curPageNum - 5
    if pStart < 1
      needAddEnd = 1 - pStart
      pStart = 1

    pEnd = curPageNum + 5
    if pEnd > pagesCount
      needAddStart = pEnd - pagesCount
      pEnd = pagesCount;
    if pEnd < 1
      pEnd = 1

    pagesArray = for pageNum in [pStart..pEnd]
      {pageNum, active: pageNum==curPageNum}

    pPrev = no
    if pStart > 1
      pPrev = curPageNum - 11
      if pPrev < 1
        pPrev = 1

    pNext = no
    if pEnd < pagesCount
      pNext = curPageNum + 11
      if pNext > pagesCount
        pNext = pagesCount

    pFirst = if pStart > 1 then 1 else no
    pLast = if pEnd < pagesCount then pagesCount else no

    @setProperties {pPrev, pNext, pFirst, pLast}

    pagesArray
  ).property "pageSize", "allCount", 'curPageNum'

  showPaginator: (->
    pages = @get 'pages'
    pages.length > 1
  ).property 'pages'
