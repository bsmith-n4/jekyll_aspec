module Labels
  def self.getstatus(attrs)
    status = attrs["status"]
    if status == ("done" || "closed")
      label = "success"
    elsif status == "open"
      label = "warning"
    else
      status = "unknown"
      label = "default"
    end
  end
end
