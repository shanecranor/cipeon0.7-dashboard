export const VersionBanner = () => {
  return (
    <div className="p-version-banner">
      <p>Hack Night</p>
      <p>v0.{weeksPast(1723247838261) + 8}</p>
      <p className="rainbow">the edging of glory</p>
    </div>
  );
};

function weeksPast(start: number) {
  const currentDate = Date.now();
  const millisecondsPerWeek = 1000 * 60 * 60 * 24 * 7;
  const elapsedMilliseconds = currentDate - start;
  const weeks = Math.floor(elapsedMilliseconds / millisecondsPerWeek);
  return weeks;
}
