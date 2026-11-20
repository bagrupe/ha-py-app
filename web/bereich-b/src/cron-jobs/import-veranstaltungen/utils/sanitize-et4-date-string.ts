export const sanitizeEt4DateString = (et4DateString: string) => {
  const hasBrokenTimezone = !!et4DateString.match(/\+\d\d$/)
  return hasBrokenTimezone ? et4DateString + ':00' : et4DateString
}
