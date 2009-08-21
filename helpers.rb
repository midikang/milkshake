helpers do


def link_to url,text
  "<a href='#{url}'>#{text}</a>"
end

def page_link page
  "<a href=\"#{page.path}\">#{page.title}</a>"
end
    
def navmenu(pages=:roots,opts={})
  pages = @page.respond_to?(pages) ? @page.send(pages) : Page.roots
  output = "<ul>"
  pages.each{ |page| output << "\n<li><a href=\"#{page.url}\">#{page.title}</a></li>"}
  output << "\n</ul>"
end 
  
def shakedown(text)
  text.gsub!(/(%\s*=\s*)(\w+\s*)\(?(\w*)\)?/) { |match| send($2) }
  RDiscount.new(text).to_html.gsub('h1>','h3>').gsub('h2>','h4>')
end

def render_partial(template,locals=nil)
  if template.is_a?(String) || template.is_a?(Symbol) # check if the template argument is a string or symbol
    template=('_' + template.to_s).to_sym # make sure the template is a symbol
  else # otherwise is must be an object
    locals=template # set the object as the local variable
    template=template.is_a?(Array) ? ('_' + template.first.class.to_s.downcase).to_sym : ('_' + template.class.to_s.downcase).to_sym #extract the template name from the object name
  end
  if locals.is_a?(Hash) # this means that the locals have been set manually, so just render the template using those variables
    erb(template,{:layout => false},locals)      
  elsif locals # otherwise, the locals will be the same name as the partial
    locals=[locals] unless locals.respond_to?(:inject) # a simple object won't repsond to the inject method, but if it is put into an array on its own it will
    locals.inject([]) do |output,element| # cycle through setting each local variable
      output << erb(template,{:layout=>false},{template.to_s.delete("_").to_sym => element})
    end.join("\n") # join up each partial with a new line to make the output html look nicer
  else # if there are no locals then just render the partial with that name
    erb(template,{:layout => false})
  end
end
  
  
end