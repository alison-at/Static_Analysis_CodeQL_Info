import python

from Call call, Name name
where
  call.getFunc() = name and
  name.getId() = "urlunparse"
select call, "Call to 'urlunparse'."
