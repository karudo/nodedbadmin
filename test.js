(function() {
  function checkForAll(inArray, needArray) {
    var _i, _len;
    for (_i = 0, _len = needArray.length; _i < _len; _i++) {
      if (_.indexOf(inArray, needArray[_i]) < 0) {
        return false;
      }
    }
    return true;
  }
  function checkForAny(inArray, needArray) {
    var _i, _len;
    for (_i = 0, _len = needArray.length; _i < _len; _i++) {
      if (_.indexOf(inArray, needArray[_i]) > -1) {
        return true;
      }
    }
    return false;
  }

  function encodeStr(str) {
    str = str.replace(':', '#DV#');
    str = str.replace(';', '#TZ#');
    str = str.replace('*', '#ST#');
    str = str.replace('-', '#MI#');
    str = encodeURIComponent(str);
    return str;
  }
  function decodeStr(str) {
    str = decodeURIComponent(str);
    str = str.replace('#DV#', ':');
    str = str.replace('#TZ#', ';');
    str = str.replace('#ST#', '*');
    str = str.replace('#MI#', '-');
    return str;
  }
  function serializeData(obj) {
    var s = [];
    if (obj.allShowed) {
      s.push('allShowed:1');
    } else {
      s.push('curPage:' + obj.curPage);
    }
    s.push('sortBy:' + (obj.sortBy || 'default'));
    if (obj.sortBy !== 'default' && obj.sortBy !== 'search') {
      s.push('sortOrder:' + obj.sortOrder);
    }
    if (obj.filter.name_p) {
      s.push('text:' + encodeStr(obj.filter.name_p));
    }
    if (obj.filter.priceFrom) {
      s.push('priceFrom:' + obj.filter.priceFrom);
    }
    if (obj.filter.priceTo) {
      s.push('priceTo:' + obj.filter.priceTo);
    }
    if (obj.filter.avails) {
      s.push('avails:' + _.keys(obj.filter.avails).join(','))
    }
    if (obj.filter.props) {
      s.push('props:' + _.map(obj.filter.props, function(prpVals, prpCode) {
        return prpCode + '-' + _.map(prpVals, encodeStr).join(',');
      }).join('*'));
    }
    return s.join(';');
  }
  function unserializeData(fltStr) {
    var
      fltJSON = {filter:{}},
      i, k, exp1,
      propsCollect, expProp,
      varsAndVals = fltStr.split(';');
    for (i = 0; i < varsAndVals.length; i++) {
      exp1 = varsAndVals[i].split(':');
      if (exp1[0] == 'priceFrom' || exp1[0] == 'priceTo') {
        fltJSON.filter[exp1[0]] = intval(exp1[1]);
      } else if (exp1[0] == 'avails') {
        fltJSON.filter.avails = {};
        _.each(exp1[1].split(','), function(code) {
          fltJSON.filter.avails[code] = true;
        })
      } else if (exp1[0] == 'props') {
        fltJSON.filter.props = {};
        propsCollect = exp1[1].split('*');
        for (k = 0; k < propsCollect.length; k++) {
          expProp = propsCollect[k].split('-');
          fltJSON.filter.props[expProp[0]] = _.map(expProp[1].split(','), decodeStr);
        }
      } else if (exp1[0] == 'text') {
        fltJSON.filter.name_p = decodeStr(exp1[1]);
      } else if (exp1[0] == 'curPage') {
        fltJSON.curPage = intval(exp1[1]);
      } else if (exp1[0] == 'allShowed') {
        fltJSON.allShowed = exp1[1] === '1' ? true : false;
      } else {
        fltJSON[exp1[0]] = exp1[1];
      }
    }
    return fltJSON;
  }

  function getParsedHash() {
    var fltStr = location.hash.split('#flt-')[1];
    if (_.isString(fltStr)) {
      return unserializeData(fltStr);
    }
    return null;
  }

  function intval(n) {
    n = parseInt(n, 10);
    if (isNaN(n)) {
      n = 0;
    }
    return n;
  }

  var FilterHash = Class.extend({
    init: function(params) {
      var _this = this;
      _this._onChangeCb = $.Callbacks();
      _this.curPageUrl = params.curPageUrl;
      _this.firstChangeState = true;
      if (TC.vars.isHashChange && _.isFunction(window.addEventListener)) {
        window.addEventListener('hashchange', function() {
          _this._onChangeCb.fire( getParsedHash() );
        }, false);
      }
    },
    onChange: function(cb) {
      this._onChangeCb.add(cb);
    },
    change: function(obj) {
      obj = _.clone(obj);
      obj.directlyChanged = true;
      this._onChangeCb.fire(obj);
      var str = serializeData(obj);
      if (TC.vars.canHistoryReplace) {
        if (this.firstChangeState) {
          this.firstChangeState = false;
          history.replaceState(null, null, this.curPageUrl + "#flt-" + str)
        } else {
          history.pushState(null, null, this.curPageUrl + "#flt-" + str)
        }
      } else {
        location.href = location.href.split('#')[0] + "#flt-" + str;
      }
      if (TC.vars.canUseLS) {
        localStorage.setItem('lastFilterHash', str);
      }
    },
    getLastHash: function() {
      var lh;
      if (TC.vars.canUseLS) {
        lh = localStorage.getItem('lastFilterHash');
        if (lh) {
          return unserializeData(lh);
        }
      }
      return false;
    }
  });

  window.TCSectionList = TCSectionList = {
    run: function(params) {
      var filterObj, listObj,
        asc = $.cookie('allShowed'),
        defaultParams = {
          allShowed: (asc === null ? !TC.vars.isMobile.any() : (asc == '1')),
          sortBy: (TC.vars.isSearch ? 'search' : ($.cookie('sortBy') || 'default')),
          sortOrder: ($.cookie('sortOrder') || 'asc'),
          filter:{}
        },
        _dp,
      //_strOldFilter = location.hash.split('#filter-')[1],
        hashObj = new FilterHash({curPageUrl: params.curPageUrl}),
        curHref = location.href+'';

      $('a').each(function() {
        var link = $(this).attr('href')+'';
        if (link.indexOf('logout=yes') > -1) {
          link = link.replace('logout=yes', 'logout=yes&lbf=y');
          $(this).attr('href', link);
        }
      });
      if (curHref.indexOf('login=yes') > -1 || curHref.indexOf('lbf=y') > -1) {
        _dp = hashObj.getLastHash()
      } else {
        _dp = getParsedHash()
      }

      if (!_.isEmpty(_dp)) {
        defaultParams = _dp;
      }

      _.each(params.filter.PROPS, function(p) {
        p.arValues = _.map(p.VALUES, function(v) {return v.val;})
      });

      _.each(params.items, function(i) {
        i.NAME_S = i.NAME.toLowerCase();
        i.TEXT_S = i.TEXT.toLowerCase();
        i.SHOPS = _.map(params.shops.Shops, function(shop) {
          return {
            LETTER: shop.LETTER,
            LABEL: shop.LABEL,
            AVAIL: !!i.SHOPS_AVAIL[shop.CODE]
          }
        });
      })

      filterObj = new TCSectionList.Filter({
        filterContent: params.filter,
        itemsContent: params.items,
        shops: params.shops.Shops,
        defaultFilter: defaultParams.filter
      });
      listObj = new TCSectionList.Items(params.items, params.filter, defaultParams || {});
      filterObj.onChange(function(fa) {
        hashObj.change( listObj.getParams({filter:fa}) );
      });
      listObj.onChangePage(function(pageNum, cb) {
        var params = listObj.getParams();
        if (pageNum == 'all') {
          params.allShowed = !listObj.allShowed;
        } else {
          params.curPage = pageNum;
          params.allShowed = false;
        }
        hashObj.change(params);
        cb();
      });
      listObj.onSort((function() {
        var lastSortBy;
        return function(sortBy, sortOrder) {
          sortOrder = (lastSortBy === sortBy || (!lastSortBy && sortBy != 'default')) ? (sortOrder === 'asc' ? 'desc' : 'asc') : sortOrder;
          hashObj.change( listObj.getParams({sortBy: sortBy, sortOrder: sortOrder}) );
          lastSortBy = sortBy;
        }
      })());
      hashObj.onChange(function(params) {
        if (!params.directlyChanged || params.fromOldFilter) {
          filterObj.render(params.filter);
        }
        listObj.applyFilter(params.filter, params);
      });
//			if (_strOldFilter) {
//				$.getJSON('/ajax/convert_filter_vars.php', {urlFilter: _strOldFilter}, function(r) {
//					if (!r.error) {
//						hashObj.change(r);
//					}
//				})
//			} else {
      hashObj.change(defaultParams);
//			}
    },

    _tpls: {},
    tpl: function(tplName) {
      var args = _.toArray(arguments).slice(1);
      if (!this._tpls[tplName]) {
        this._tpls[tplName] = TCSectionList.getHBTplFunc('hbsTpl-'+tplName);
      }
      return this._tpls[tplName].apply(null, args);
    },

    getHBTplFunc: function(id) {
      var source = $("#"+id).html();
      return Handlebars.compile(source);
    }
  };

  /* items list controller */
  TCSectionList.Items = Class.extend({
    init: function(items, filter, params) {
      var _this = this;

      params || (params = {});

      _this._onRenderCb  = $.Callbacks();
      _this._onChangePageCb  = $.Callbacks();
      _this._onSortCb  = $.Callbacks();

      _this.itemsContent = items;
      _this.filterContent = filter;

      this.items = [];
      this.filteredItems = [];
      this.sortBy = params.sortBy || 'default';
      this.sortOrder = params.sortOrder || 'asc';
      this.itemsPerPage = params.itemsPerPage || 15;
      this.curPage = params.curPage || 1;
      this.allShowed = params.allShowed || !TC.vars.isMobile.any();


      TC.cb.add('catalog:sort', function() {
        _this._onSortCb.fire($(this).data('rel')+'', _this.sortOrder);
      });

      $('#catalog-list').on('click', '.pagelink', function(event) {
        event.preventDefault();
        var pageNum = $(this).data('page'),
          scroll_to_id = (pageNum == 'all' && !_this.allShowed) ? $('#catalog-list .item').last().attr('id') : 'catalog-list';
        _this._onChangePageCb.fire(pageNum, function() {
          $.scrollTo($("#"+scroll_to_id), 800);
        });
      })

    },
    getParams: function(extParams) {
      return _.extend({
        curPage: this.curPage,
        allShowed: this.allShowed,
        sortBy: this.sortBy,
        sortOrder: this.sortOrder,
        filter: this.filterVars
      }, extParams);
    },
    applyFilter: function(filterVars, params) {
      var
        _this = this,
        newItems,
        name_p = filterVars.name_p ? (filterVars.name_p + '').toLowerCase() : false,
        findShops = filterVars.avails && _.keys(filterVars.avails),
        searchByShops = !_.isEmpty(findShops),
        searchByProps = !_.isEmpty(filterVars.props);

      this.filterVars = filterVars;

      filterVars.priceFrom = filterVars.priceFrom || 0;
      filterVars.priceTo = filterVars.priceTo || 0;

      params || (params = {allShowed: _this.allShowed});

      newItems = _.filter(_this.itemsContent, function(item) {
        var prpCode, prpInfo, inArray;

        if (searchByShops && !checkForAny(_.keys(item.SHOPS_AVAIL), findShops)) {
          return false;
        }

        if (filterVars.priceFrom > 0) {
          if (item.PRICE.PRICE < filterVars.priceFrom) {
            return false;
          }
        }

        if (filterVars.priceTo > 0) {
          if (item.PRICE.PRICE > filterVars.priceTo) {
            return false;
          }
        }

        if (name_p && name_p.length > 0) {
          if ( !(item.NAME_S.indexOf(name_p) > -1 || item.TEXT_S.indexOf(name_p) > -1) ) {
            return false;
          }
        }

        if (searchByProps) {
          for (prpCode in filterVars.props) {
            prpInfo = _this.filterContent.PROPS[prpCode];
            inArray  = item.PROPS[prpCode];
            if (!_.isArray(inArray)) {
              inArray = [inArray];
            }
            if (!((prpInfo && prpInfo.AND) ? checkForAll : checkForAny)(inArray, filterVars.props[prpCode])) {
              return false;
            }
          }
        }
        return true;
      });
      this.setItems(newItems, params);
      TC.filter.setNumItems(newItems.length)
    },
    _sort_search: function(a, b) {
      if (a.hasOwnProperty('S_SORT') && b.hasOwnProperty('S_SORT')) {
        if (a.S_SORT > b.S_SORT) {
          return 1;
        } else if (a.S_SORT < b.S_SORT) {
          return -1;
        }
      } else if (a.hasOwnProperty('S_SORT')) {
        return -1;
      } else if (b.hasOwnProperty('S_SORT')) {
        return 1;
      }
      return 0;
    },
    _sort_default: function(a, b) {
      var r;
      if (a.CANBUY !== b.CANBUY) {
        r = a.CANBUY ? -1 : 1
      } else if (a.P_SORT > b.P_SORT) {
        r = -1;
      } else if (a.P_SORT > b.P_SORT) {
        r = 1;
      } else {
        if (a.SORT > b.SORT) {
          r = 1;
        } else if (a.SORT < b.SORT) {
          r = -1;
        } else {
          r = 0;
        }
      }
      return r;
    },
    _sort_title: function(a, b) {
      var desc = this.sortOrder == 'desc' ? -1 : 1;
      if (a.NAME < b.NAME) {
        return -1 * desc;
      } else if (a.NAME > b.NAME) {
        return 1 * desc;
      }
      return 0;
    },
    _sort_price: function(a, b) {
      var desc = this.sortOrder == 'desc' ? -1 : 1;
      if (a.PRICE.PRICE < b.PRICE.PRICE) {
        return -1 * desc;
      } else if (a.PRICE.PRICE > b.PRICE.PRICE) {
        return 1 * desc;
      }
      return 0;
    },
    render: function(params) {
      params || (params = {});
      var _this = this,
        i,
        startFromItem = ((this.curPage - 1) * this.itemsPerPage),
        allItems,
        items,
        html,
        sortBy = params.sortBy || _this.sortBy,
        sortFunc = _.isFunction(this['_sort_' + sortBy]) ? this['_sort_' + sortBy] : this._sort_default,
        compareItems = _.map(($.cookie('COMPARE_LIST') || '').split(':'), intval),
        catView = $.cookie('catView') || 'tiles';

      allItems = this.items.sort(function(a, b) {
        return sortFunc.call(_this, a, b);
      });
      if (this.allShowed) {
        items = allItems;
      } else {
        items = allItems.slice(startFromItem, startFromItem + this.itemsPerPage);
      }
      i = 0;
      _.each(items, function (item) {
        item.clearleft = (i++ % 3) < 1;
        item.IN_COMPARE = ~_.indexOf(compareItems,item.ID);
      });
      html = TCSectionList.tpl('list', {
        items: items,
        allItemsCount: allItems.length,
        itemsPerPage: this.itemsPerPage,
        curPage: this.curPage,
        allShowed: this.allShowed,
        sortBy: {
          'default': sortBy === 'default',
          title: sortBy === 'title',
          price: sortBy === 'price'
        },
        sortOrderDesc: this.sortOrder === 'desc',
        catView: catView,
        compareSize: compareItems.length
      });
      $('#catalog-list').html(html);
      $('.cat-list-view a.'+catView).trigger('click');
      TC.catalog.listFix();
      $('#catalog-list .checkbox').checkbox();
      _this._onRenderCb.fire(_this);
    },
    onRender: function(cb) {
      this._onRenderCb.add(cb)
    },
    onChangePage: function(cb) {
      this._onChangePageCb.add(cb);
    },
    onSort: function(cb) {
      this._onSortCb.add(cb);
    },
    setItems: function(items, params) {
      if (!params) {
        params = {};
      }
      this.items = items;
      if (params.allShowed) {
        this.setAllShowed(true, false);
      } else {
        this.setCurPage((params.curPage || 1), false);
      }
      if (params.sortBy && params.sortOrder) {
        this.setSort(params.sortBy, params.sortOrder, false)
      }
      this.render(params);
    },
    setSort: function(sortBy, sortOrder, render) {
      this.sortBy = sortBy;
      this.sortOrder = sortOrder === 'asc' ? 'asc' : 'desc';
      if (this.sortBy != 'search')
        $.cookie('sortBy', this.sortBy, {expires: 500, path: '/'});
      $.cookie('sortOrder', this.sortOrder, {expires: 500, path: '/'});
      if (!(render===false)) {
        this.render();
      }
    },
    setCurPage: function(page, render) {
      page = intval(page);
      if (page < 1) {
        page = 1;
      }
      this.allShowed = false;
      this.curPage = page;
      if (!(render===false)) {
        this.render();
      }
    },
    setAllShowed: function(allShowed, render) {
      this.allShowed = !!allShowed;
      this.curPage = 1;
      $.cookie('allShowed', this.allShowed?1:0, {expires: 500, path: '/'});
      if (!(render===false)) {
        this.render();
      }
    }
  });

  /* filter controller */
  TCSectionList.Filter = Class.extend({
    init: function(props) {
      _this = this;
      _this._tpls = {};
      _this._onChangeCb = $.Callbacks();
      _this.itemsContent = props.itemsContent;
      _this.filterContent = _.clone(props.filterContent);
      _this.shops = _.clone(props.shops);
      if (!props.defaultFilter) {
        props.defaultFilter = {};
      }

      _this.MIN_PRICE = 0;
      _this.MAX_PRICE = 0;

      _.each(_this.itemsContent, function(item) {
        if (item.PRICE.PRICE > _this.MAX_PRICE) {
          _this.MAX_PRICE = item.PRICE.PRICE;
        } else {
          if (_this.MIN_PRICE === 0 || item.PRICE.PRICE < _this.MIN_PRICE) {
            _this.MIN_PRICE = item.PRICE.PRICE;
          }
        }
      })

      _this.MAX_PRICE || (_this.MAX_PRICE = 50000);

      _this.MIN_PRICE = Math.floor(_this.MIN_PRICE / 50) * 50
      _this.MAX_PRICE = Math.ceil(_this.MAX_PRICE / 50) * 50

      _this.CUR_MIN_PRICE = intval(props.defaultFilter.priceFrom);
      if (!_this.CUR_MIN_PRICE) _this.CUR_MIN_PRICE = _this.MIN_PRICE;
      _this.CUR_MAX_PRICE = intval(props.defaultFilter.priceTo);
      if (!_this.CUR_MAX_PRICE) _this.CUR_MAX_PRICE =_this.MAX_PRICE;

      _this.RangeObj = new TCSectionList.FilterRange();

      _this.render(props.defaultFilter);

      TC.cb.add('filter:change', function() {
        _this.setFilterVars( _this.getVars() );
      });
    },
    render: function(curFilter) {
      _.each(_this.shops, function(shop) {
        shop.SELECTED = curFilter.avails && !!curFilter.avails[shop.CODE];
      });

      _.each(_this.filterContent.PROPS, function(prop) {
        var c = 2;
        prop.NOT_SELECTED = !(curFilter.props && curFilter.props[prop.id] && curFilter.props[prop.id].length > 0);
        _.each(prop.VALUES, function(value) {
          var pVals;
          if (prop.NOT_SELECTED) {
            value.SELECTED = false;
          } else {
            pVals = curFilter.props[prop.id];
            value.SELECTED = pVals.indexOf(value.val) > -1;
          }
          value.NEW_UL = !(c % 4);
          c++;
        })
      });
      var curPriceFrom = curFilter.priceFrom || this.MIN_PRICE,
        curPriceTo = curFilter.priceTo || this.MAX_PRICE;

      $('#main-filter-form').html( TCSectionList.tpl('filter', {
        main_props: _.filter(_this.filterContent.PROPS, function(prp) {return prp.SORT <= 10;}),
        ex_props: _.filter(_this.filterContent.PROPS, function(prp) {return prp.SORT > 10;}),
        shops: _this.shops,
        MIN_PRICE: this.MIN_PRICE,
        MAX_PRICE: this.MAX_PRICE,
        CUR_MIN_PRICE: curPriceFrom,
        CUR_MAX_PRICE: curPriceTo,
        NAME_P: curFilter.name_p
      }) );

      TC.filter.init();
      $('#filter .checkbox').checkbox();
      TC.initPlaceHolders();
      $('#filter>.value-specs').last().addClass('value-last');
      this.RangeObj.setCurFromTo(curPriceFrom, curPriceTo);
    },
    getVars: function() {
      var postvars = {},
        priceFrom = intval($("#priceRange-from").attr("data-val")),
        priceTo = intval($("#priceRange-to").attr("data-val"));

      if ( !(priceFrom > 0) ) priceFrom =  intval($("#priceRange-from").val());
      if ( !(priceTo > 0) ) priceTo =  intval($("#priceRange-to").val());

      if(!$('#filter-keywords').hasClass("textInput-placeholder")) postvars.name_p = $('#filter-keywords').val();
      if (priceFrom > 0 && priceFrom != this.MIN_PRICE) postvars.priceFrom = priceFrom;
      if (priceTo > 0 && priceTo != this.MAX_PRICE) postvars.priceTo = priceTo;

      function props_collect_callback() {
        var prop_code = $(this).attr('data-prop-code'),
          prop_value = $(this).attr('data-prop-value');

        if (prop_value.length > 0) {
          if (_.isEmpty(postvars.props)) {
            postvars.props = {}
          }
          if(!(prop_code in postvars.props)) {
            postvars.props[prop_code] = [];
          }

          postvars.props[prop_code].push(prop_value);
        }
      }
      function avails_collect_callback() {
        var prop_code = $(this).attr('data-prop-code');
        if (_.isEmpty(postvars.avails)) {
          postvars.avails = {}
        }
        postvars.avails[prop_code] = true;
      }

      $('#filter .checkbox-checked input,#filter .value-cats a.active').each(props_collect_callback);
      $('#filter .availability a').not(".inactive").each(avails_collect_callback);
      return postvars;
    },
    setFilterVars: function(filterVars) {
      _this._onChangeCb.fire(filterVars);
    },
    onChange: function(cb) {
      this._onChangeCb.add(cb)
    }
  });

  TCSectionList.FilterRange = Class.extend({
    init: function() {
      this.$mainFilterForm = $('#main-filter-form');
      console.log( this.$range().data('min-price') )

      this.$('.handler').each(function() {
        console.log(arguments)
      })
    },
    rng: function {
      return $('#priceRange', this.$mainFilterForm);
    },
    $: function (sel) {
      return $(sel, this.$range());
    },
    setCurFromTo: function(from, to) {
      console.log(from, to)
    }
  });

  Handlebars.registerHelper('logg', function() {
    TC.util.log('logg', arguments)
    return '';
  });

  Handlebars.registerHelper('paginator', function(itemsCount, itemsPerPage, curPage, allShowed) {
    var i, pStart, needAddEnd = 0, pEnd, needAddStart = 0, params = {
      allShowed: allShowed,
      pages: []
    };
    params.pagesCount = Math.ceil( itemsCount / itemsPerPage );
    pStart = curPage - 2;
    if (pStart < 1) {
      needAddEnd = 1 - pStart;
      pStart = 1;
    }

    pEnd = curPage + 2;
    if (pEnd > params.pagesCount) {
      needAddStart = pEnd - params.pagesCount;
      pEnd = params.pagesCount;
    }

    pStart -= needAddStart;
    pEnd += needAddEnd;

    if (pStart < 1) {
      pStart = 1;
    }
    if (pEnd > params.pagesCount) {
      pEnd = params.pagesCount;
    }

    for (i = pStart; i <= pEnd; i++ ) {
      params.pages.push({
        page: i,
        isCurPage: (i == curPage),
        addclass: (i == (curPage - 1) ? 'prev' : (i == (curPage + 1) ? 'next' : false))
      });
    }

    return new Handlebars.SafeString( TCSectionList.tpl('paginator', params) );
  });

  Handlebars.registerHelper('include', function(tplName) {
    var i, params = {}, args = _.toArray(arguments).slice(1);
    for (i = 0; i < args.length; i++) {
      params['arg'+i] = args[i];
    }
    return new Handlebars.SafeString( TCSectionList.tpl(tplName, params) );
  });
  Handlebars.registerHelper('checked', function(v) {
    var res;
    if (v)
      res = ' checked="checked" ';
    else
      res = '';
    return new Handlebars.SafeString(res);
  });
})();
