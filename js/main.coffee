(->
	globals =
		schedule : ''

	fnRangeCalendar = ->
		dom = {}
		st =
			toDate 		: '#toDate'
			fromDate 	: '#fromDate'
		catchDom = ->
			dom.toDate 		= $(st.toDate)
			dom.fromDate 	= $(st.fromDate)
			return
		afterCatchDom = ->
			dom.toDate.datepicker(
				changeMonth: true
				changeYear: true
				dateFormat: 'dd/mm/yy'
				maxDate: "+2Y"
				minDate: 0
				numberOfMonths: 3
				onClose: (selectedDate )->
					dom.fromDate.datepicker( "option", "minDate", selectedDate )
					return
				)
			dom.fromDate.datepicker(
				changeMonth: true
				changeYear: true
				dateFormat: 'dd/mm/yy'
				maxDate: "+2Y"
				minDate: 0
				numberOfMonths: 3
				onClose: (selectedDate )->
					dom.toDate.datepicker( "option", "maxDate", selectedDate )
					return
				)
			return

		init = ->
			catchDom()
			afterCatchDom()
			return
		init()
		return

	fnLoadingButtons = ->
		dom = {}
		st =
			buttons : '.btn-search, .btn-add'
		catchDom = ->
			dom.buttons = $(st.buttons)
			return
		afterCatchDom = ->
			dom.buttons.ladda('bind')
			return
		init = ->
			catchDom()
			afterCatchDom()
			return
		init()
		return
	fnInitTable = ->
		dom = {}
		st =
			tables : '#tables'
		catchDom = ->
			dom.tables = $(st.tables)
			return
		afterCatchDom = ->
			dom.tables.dataTable()
			return
		init = ->
			catchDom()
			afterCatchDom()
			return
		init()
		return
	fnSearchDNI = ->
		dom = {}
		st =
			url 	: "http://marti1125.webfactional.com/reniec/index.php/verificar/"
			dni 	: "48754156"
			button 	: "#searchDNI"
			txtDNI 		: "#txtDNI"
			txtName 	: '#txtName'
			txtAddress 	: '#txtAddress'
			currentValue: null
		catchDom = ->
			dom.button = $(st.button)
			dom.txtDNI 		= $(st.txtDNI)
			dom.txtName 	= $(st.txtName)
			dom.txtAddress 	= $(st.txtAddress)
			return
		suscribeEvents = ->
			dom.button.on 'click', events.eSearchDNI
			dom.txtDNI.on 'change', events.eCleanForm
			dom.txtDNI.on 'keyup', events.eCleanForm
			return
		events =
			eSearchDNI : (e) ->
				dni = dom.txtDNI.val()
				if dni == ""
					dom.txtDNI.val(st.dni)
					dni = st.dni
				st.currentValue = dni
				$.ajax(
					url 		: "#{st.url}#{dni}"
					crossDomain : true
					type		: "GET"
					dataType 	: "json"
				).done((data)->
					if data.length > 0
						obj = data[0]
						dom.txtName.val(obj.nombre_completo)
						dom.txtAddress.val(obj.direccion)
					else
						alert('DNI no encontrado')
					return
				).always((data)->
					dom.button.removeAttr('disabled')
					dom.button.removeAttr('data-loading')
					return
				)
				return
			eCleanForm : (e)->
				if $(@).val() != st.currentValue
					dom.txtName.val('')
					dom.txtAddress.val('')
				return
		init = ->
			catchDom()
			suscribeEvents()
			return
		init()
		return

	fnSearchRUC = ->
		dom = {}
		st =
			url		: "http://marti1125.webfactional.com/sunat/index.php/verificar/"
			ruc		: "20546462324"
			button	: "#searchRUC"
			txtRUC				: "#txtRUC"
			txtCompanyName		: '#txtCompanyName'
			txtCompanyAddress	: '#txtCompanyAddress'
			currentValue: null
		catchDom = ->
			dom.button				= $(st.button)
			dom.txtRUC				= $(st.txtRUC)
			dom.txtCompanyName		= $(st.txtCompanyName)
			dom.txtCompanyAddress	= $(st.txtCompanyAddress)
			return
		suscribeEvents = ->
			dom.button.on 'click', events.eSearchRUC
			dom.txtRUC.on 'change', events.eCleanForm
			dom.txtRUC.on 'keyup', events.eCleanForm
			return
		events =
			eSearchRUC : (e) ->
				ruc = dom.txtRUC.val()
				if ruc == ""
					dom.txtRUC.val(st.ruc)
					ruc = st.ruc
				st.currentValue = ruc
				$.ajax(
					url 		: "#{st.url}#{ruc}"
					crossDomain : true
					type		: "GET"
					dataType 	: "json"
				).done((data)->
					if data.length > 0
						obj = data[0]
						dom.txtCompanyName.val(obj.nombre)
						dom.txtCompanyAddress.val(obj.direccion)
					else
						alert('RUC no encontrado')
					return
				).always((data)->
					dom.button.removeAttr('disabled')
					dom.button.removeAttr('data-loading')
					return
				)
				return
			eCleanForm : (e)->
				if $(@).val() != st.currentValue
					dom.txtCompanyName.val('')
					dom.txtCompanyAddress.val('')
				return
		init = ->
			catchDom()
			suscribeEvents()
			return
		init()
		return
	fnValidate = ->
		dom = {}
		st =
			form : '#form_register'
		catchDom = ->
			dom.form = $(st.form)
			return
		afterCatchDom = ->
			dom.form.validate(
				rules:
					txtDNI:
						minlength	: 8
						number		: true
						required	: true
					txtRUC:
						minlength	: 11
						number		: true
						required	: true
					txtPhoneNumber:
						minlength 	: 7
						number 		: true
						required 	: true
				submitHandler: (form) ->
					if $('.heavyMachinerySelected').length > 0
						$(form).submit()
					else
						alert('Elija almenos una maquinaria pesada')
					return
				)
			return
		init = ->
			catchDom()
			afterCatchDom()
			return
		init()
		return

	fnGetHeavyMachinery = ->
		dom = {}
		st =
			btnAdd		: '#btnAddMachinery'
			urlMachinaries : 'http://willyaguirre.me/RestMaquinaria/api/Maquinaria/codigomaquinaria'
			urlPrices : 'http://willyaguirre.me/RestMaquinaria/api/Maquinaria/obtenerprecio/'
			select : '#heavyMachinery'
			currentPrice : '#txtCurrentPrice'
			calendar : '#calendar'
			urlSchedule : 'http://willyaguirre.me/RestMaquinaria/api/Maquinaria/obtenerfechas/'
		catchDom = ->
			dom.select = $(st.select)
			dom.currentPrice = $(st.currentPrice)
			dom.btnAdd = $(st.btnAdd)
			return
		suscribeEvents = ->
			dom.select.on 'change', events.getPrice
			return
		afterCatchDom = ->
			$.ajax(
				url 		: "#{st.urlMachinaries}"
				crossDomain : true
				type		: "GET"
				dataType 	: "json"
			).done((data)->
				options = "<option value=''>--------- Seleccione ---------</option>"
				if data.length > 0
					$.each(data, (index, value)->
						options += "<option value='#{value.codigo}'>#{value.nombreMaquinaria}</option>"
						return
						)
					dom.select.html(options)
					suscribeEvents()
				else
					alert('No hay maquinarias')
				return
			).always((data)->
				return
			).fail((jqXHR, textStatus, errorThrown)->
				afterCatchDom()
				return
			)
			return
		events =
			getPrice : (e) ->
				dom.currentPrice.val("")
				dom.currentPrice.data("perhour", "")
				dom.btnAdd.attr('disabled', 'disabled')
				dom.btnAdd.attr('data-loading', '')
				codigo = dom.select.val()
				$.ajax(
					url 		: "#{st.urlPrices}#{codigo}"
					crossDomain : true
					type		: "GET"
					dataType 	: "json"
				).done((data)->
					dom.currentPrice.val("S/. #{data.precio}")
					dom.currentPrice.attr("data-perhour", data.precio)
					$(st.calendar).fullCalendar('destroy')
					globals.schedule = ''
					$.ajax(
						url 		: "#{st.urlSchedule}#{codigo}"
						crossDomain : true
						type		: "GET"
						dataType 	: "json"
					).done((data)->
						if data != ''
							globals.schedule = data.eventos
							$(st.calendar).fullCalendar
								lang: 'es'
								defaultView: 'month'
								eventSources: [
									events	 : data.eventos
									color	 : '#26A2E0'
									textColor:'white'
								]
						return
					).always((data)->
						dom.btnAdd.removeAttr('disabled')
						dom.btnAdd.removeAttr('data-loading')
						return
					).fail((jqXHR, textStatus, errorThrown)->
						return
					)
					return
				).always((data)->
					return
				).fail((jqXHR, textStatus, errorThrown)->
					return
				)
				return
		init = ->
			catchDom()
			afterCatchDom()
			return
		init()
		return
	fnActiveCalendar = ->
		dom = {}
		st =
			container : '#calendar'
			
		catchDom = ->
			dom.container = $(st.container)
			return
		afterCatchDom = ->
			dom.container.fullCalendar
				lang: 'es'
				defaultView: 'month'
			return
		init = ->
			catchDom()
			afterCatchDom()
			return
		init()
		return
	fnAddHeavyMachinery = ->
		dom = {}
		st =
			finalPrice	: '#finalPrice'
			btnAdd		: '#btnAddMachinery'
			selMachinery: '#heavyMachinery'
			txtPrice	: '#txtCurrentPrice'
			toDate		: '#toDate'
			fromDate	: '#fromDate'
			container	: '.heavyMachineryItems'
			finalPriceHTML: '.finalPriceHTML'
			items : '.heavyMachinerySelected'

		catchDom = ->
			dom.btnAdd 		= $(st.btnAdd)
			dom.selMachinery= $(st.selMachinery)
			dom.txtPrice 	= $(st.txtPrice)
			dom.toDate	 	= $(st.toDate)
			dom.fromDate	= $(st.fromDate)
			dom.container	= $(st.container)
			dom.finalPrice	= $(st.finalPrice)
			dom.finalPriceHTML= $(st.finalPriceHTML)
			return
		suscribeEvents = ->
			dom.btnAdd.on 'click', events.eAddMachinery
			dom.container.on 'click', '.heavyMachineryDelete', events.eDeleteItem
			return
		events = 
			eAddMachinery: (e) ->
				e.preventDefault()
				if functions.isValid()
					functions.drawItem()
					functions.cleanForm()
				else
					alert('Ingrese los datos de la maquinaria correctamente')
				setTimeout(->
						dom.btnAdd.removeAttr('disabled')
						dom.btnAdd.removeAttr('data-loading')
						return
					, 50)
				return
			eDeleteItem: (e) ->
				currentCost = parseFloat($(@).parent().find('.txtHeavyMachineryCost').val())
				console.log currentCost
				newCost = parseFloat(dom.finalPriceHTML.html()) - currentCost
				dom.finalPrice.val(newCost)
				dom.finalPriceHTML.html(newCost)
				$(@).parent().remove()
				return
		functions =
			drawItem : () ->
				cost = parseFloat(dom.txtPrice.attr('data-perhour'))
				fromDate = $.datepicker.parseDate('dd/mm/yy', dom.fromDate.val())
				toDate = $.datepicker.parseDate('dd/mm/yy', dom.toDate.val())
				diffTime = Math.abs(fromDate.getTime() - toDate.getTime())
				hours = Math.ceil(diffTime / (1000 * 3600 ))
				finalCost = hours * cost
				html = "<div class='heavyMachinerySelected'>
							<div class='heavyMachineryName'>
								<input type='hidden' name='heavyMachineryName[]' value='#{dom.selMachinery.val()}'/>
								#{dom.selMachinery.find('option:selected').html()}
							</div>
							<div class='heavyMachineryCost'>
								<input type='hidden' class='txtHeavyMachineryCost' name='heavyMachineryCost[]' value='#{finalCost}'/>
								S/. #{finalCost}
							</div>
							<div class='heavyMachineryDate'>
								<input type='hidden' name='toDate[]' value='#{dom.toDate.val()}'/>
								<input type='hidden' name='fromDate[]' value='#{dom.fromDate.val()}'/>
								#{dom.toDate.val()} - #{dom.fromDate.val()}
							</div>
							<div class='heavyMachineryDelete'>X</div>
						</div>"
				dom.container.append(html)
				currentPrice = parseFloat(dom.finalPriceHTML.html())  + finalCost
				dom.finalPriceHTML.html(currentPrice)
				dom.finalPrice.val(currentPrice)
				return
			cleanForm : () ->
				dom.txtPrice.val('')
				dom.toDate.val('')
				dom.fromDate.val('')
				dom.selMachinery.val('')
				return
			isValid : () ->
				result = true
				machinery =  dom.selMachinery.val()
				if dom.selMachinery.val() == ''
					result = false				
				else if globals.schedule != ''
					toDate = $.datepicker.parseDate( "dd/mm/yy", dom.toDate.val())
					fromDate = $.datepicker.parseDate( "dd/mm/yy", dom.fromDate.val())
					#toDate = moment(dom.toDate.val()).format('dd/mm/yy');
					#fromDate = moment(dom.fromDate.val()).format('dd/mm/yy');
					$.each(globals.schedule, (index, element)->
						start =  $.datepicker.parseDate( "yy-mm-dd", element.start)
						end = $.datepicker.parseDate( "yy-mm-dd", element.end)
						if start < fromDate and fromDate < end
							result = false
						else if start < toDate and toDate < end
							result = false
						return)
				$(st.items).each((index, element)->
					if dom.selMachinery.find('option:selected').html() == $(element).find('.heavyMachineryName').html()
						result = false
					return
				)
				return result
		init = ->
			catchDom()
			suscribeEvents()
			return
		init()
		return

	fnAddHeavyMachinery()
	fnLoadingButtons()
	fnRangeCalendar()
	fnGetHeavyMachinery()
	#fnActiveCalendar()
	fnInitTable()
	fnSearchDNI()
	fnSearchRUC()
	fnValidate()
	return
)()